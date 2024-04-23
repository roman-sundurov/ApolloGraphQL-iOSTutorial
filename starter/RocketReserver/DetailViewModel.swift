
import SwiftUI
import RocketReserverAPI
import KeychainSwift
import Apollo

class DetailViewModel: ObservableObject {

    let launchID: RocketReserverAPI.ID

    @Published var launch: LaunchDetailsQuery.Data.Launch?
    @Published var isShowingLogin = false
    @Published var appAlert: AppAlert?
    
    init(launchID: RocketReserverAPI.ID) {
        // TODO (Section 9 - https://www.apollographql.com/docs/ios/tutorial/tutorial-complete-details-view#execute-the-query)
        self.launchID = launchID
    }

    func loadLaunchDetails(forceReload: Bool = false) {
        // TODO (Section 9 - https://www.apollographql.com/docs/ios/tutorial/tutorial-complete-details-view#execute-the-query)
        guard forceReload || launchID != launch?.id else {
            return
        }

        let cachePolicy: CachePolicy = forceReload ? .fetchIgnoringCacheData : .returnCacheDataElseFetch

        Network.shared.apollo.fetch(query: LaunchDetailsQuery(launchId: launchID), cachePolicy: cachePolicy) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let graphQLResult):
                if let launch = graphQLResult.data?.launch {
                    self.launch = launch
                }

                if let errors = graphQLResult.errors {
                    self.appAlert = .errors(errors: errors)
                }
            case .failure(let error):
                self.appAlert = .errors(errors: [error])
            }
        }
    }

    func bookOrCancel() {
        guard self.isLoggedIn() else {
            isShowingLogin = true
            return
        }
        
        // TODO (Section 12 - https://www.apollographql.com/docs/ios/tutorial/tutorial-define-additional-mutations#implement-the-canceltrip-logic)

        guard let launch = launch else {
            return
        }

        launch.isBooked ? cancelTrip(with: launch.id) : bookTrip(with: launch.id)
    }

    private func bookTrip(with id: RocketReserverAPI.ID) {
        // TODO (Section 12 - https://www.apollographql.com/docs/ios/tutorial/tutorial-define-additional-mutations#implement-the-booktrip-logic)

        Network.shared.apollo.perform(mutation: BookTripMutation(launchId: id)) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let graphQLResult):
                if let bookingResult = graphQLResult.data?.bookTrips {
                    if bookingResult.success {
                        self.appAlert = .basic(title: "Success!",
                                               message: bookingResult.message ?? "Trip booked successfully")
                        self.loadLaunchDetails(forceReload: true)
                    } else {
                        self.appAlert = .basic(title: "Could not book trip",
                                               message: bookingResult.message ?? "Unknown failure")
                    }
                }

                if let errors = graphQLResult.errors {
                    self.appAlert = .errors(errors: errors)
                }
            case .failure(let error):
                self.appAlert = .errors(errors: [error])
            }
        }
    }

    private func cancelTrip(with id: RocketReserverAPI.ID) {
        // TODO (Section 12 - https://www.apollographql.com/docs/ios/tutorial/tutorial-define-additional-mutations#implement-the-canceltrip-logic)

        Network.shared.apollo.perform(mutation: CancelTripMutation(id: id)) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let graphQLResult):
                if let cancelResult = graphQLResult.data?.cancelTrip {
                    if cancelResult.success {
                        self.appAlert = .basic(title: "Trip cancelled",
                                               message: cancelResult.message ?? "Your trip has been officially cancelled")
                        self.loadLaunchDetails(forceReload: true)
                    } else {
                        self.appAlert = .basic(title: "Could not cancel trip",
                                               message: cancelResult.message ?? "Unknown failure.")
                    }
                }

                if let errors = graphQLResult.errors {
                    self.appAlert = .errors(errors: errors)
                }
            case .failure(let error):
                self.appAlert = .errors(errors: [error])
            }
        }
    }

    private func isLoggedIn() -> Bool {
        // TODO (Section 10 - https://www.apollographql.com/docs/ios/tutorial/tutorial-first-mutation#display-the-login-view)
        // return false
        let keychain = KeychainSwift()
        return keychain.get(LoginView.loginKeychainKey) != nil
    }
    
}
