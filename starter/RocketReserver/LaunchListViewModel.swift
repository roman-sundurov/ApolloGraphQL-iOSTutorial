import SwiftUI
import Apollo
import RocketReserverAPI

class LaunchListViewModel: ObservableObject {
    
    @Published var launches = [LaunchListQuery.Data.Launches.Launch]()
    @Published var lastConnection: LaunchListQuery.Data.Launches?
    @Published var activeRequest: Cancellable?
    var activeSubscription: Cancellable?
    @Published var appAlert: AppAlert?
    @Published var notificationMessage: String?
    
    init() {
        // TODO (Section 13 - https://www.apollographql.com/docs/ios/tutorial/tutorial-subscriptions#use-your-subscription)
        // Network.shared.apollo.fetch(query: LaunchListQuery()) { result in
        //     switch result {
        //     case .success(let graphQLResult):
        //         print("Success! Result: \(graphQLResult)")
        //     case .failure(let error):
        //         print("Failure! Error: \(error)")
        //     }
        // }
        startSubscription()
    }

    // MARK: - Subscriptions

    func startSubscription() {
        // TODO (Section 13 - https://www.apollographql.com/docs/ios/tutorial/tutorial-subscriptions#use-your-subscription)
        activeSubscription = Network.shared.apollo.subscribe(subscription: TripsBookedSubscription()) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let graphQLResult):
                if let tripsBooked = graphQLResult.data?.tripsBooked {
                    self.handleTripsBooked(value: tripsBooked)
                }

                if let errors = graphQLResult.errors {
                    self.appAlert = .errors(errors: errors)
                }
            case .failure(let error):
                self.appAlert = .errors(errors: [error])
            }
        }
    }

    private func handleTripsBooked(value: Int) {
        var message: String
        switch value {
        case 1:
            message = "A new trip was booked! 🚀"
        case -1:
            message = "A trip was cancelled! 😭"
        default:
            appAlert = .basic(title: "Unexpected Value",
                              message: "Subscription returned an unexpected value: \(value)")
            return
        }
        
        notificationMessage = message
    }
    
    // MARK: - Launch Loading
    
    func loadMoreLaunchesIfTheyExist() {
        // TODO (Section 8 - https://www.apollographql.com/docs/ios/tutorial/tutorial-paginate-results#update-launchlistviewmodel-to-use-cursor)

        guard let connection = self.lastConnection else {
            self.loadMoreLaunches(from: nil)
            return
        }

        guard connection.hasMore else {
            return
        }

        self.loadMoreLaunches(from: connection.cursor)
    }

    func loadMoreLaunches(from after: String?) {
        // TODO (Section 6 - https://www.apollographql.com/docs/ios/tutorial/tutorial-connect-queries-to-ui#configure-launchlistviewmodel)

        self.activeRequest = Network.shared.apollo.fetch(query: LaunchListQuery(after: after ?? .null)) { [weak self] result in
            guard let self = self else {
                return
            }

            self.activeRequest = nil

            switch result {
            case .success(let graphQLResult):
                if let launchConnection = graphQLResult.data?.launches {
                    self.lastConnection = launchConnection
                    self.launches.append(contentsOf: launchConnection.launches.compactMap({ $0 }))
                }

                if let errors = graphQLResult.errors {
                    self.appAlert = .errors(errors: errors)
                }
            case .failure(let error):
                self.appAlert = .errors(errors: [error])
            }
        }
    }
    
}
