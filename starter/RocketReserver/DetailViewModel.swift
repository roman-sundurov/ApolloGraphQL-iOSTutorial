import SwiftUI
import RocketReserverAPI

class DetailViewModel: ObservableObject {

    let launchID: RocketReserverAPI.ID

    @Published var launch: LaunchDetailsQuery.Data.Launch?
    @Published var isShowingLogin = false
    @Published var appAlert: AppAlert?
    
    init(launchID: RocketReserverAPI.ID) {
        // TODO (Section 9 - https://www.apollographql.com/docs/ios/tutorial/tutorial-complete-details-view#execute-the-query)
        self.launchID = launchID
    }

    func loadLaunchDetails() {
        // TODO (Section 9 - https://www.apollographql.com/docs/ios/tutorial/tutorial-complete-details-view#execute-the-query)
        guard launchID != launch?.id else {
            return
        }

        Network.shared.apollo.fetch(query: LaunchDetailsQuery(launchId: launchID)) { [weak self] result in
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
    }
    
    private func bookTrip() {
        print("Book Trip!")
        // TODO (Section 12 - https://www.apollographql.com/docs/ios/tutorial/tutorial-define-additional-mutations#implement-the-booktrip-logic)
    }
    
    private func cancelTrip() {
        print("Cancel Trip!")
        // TODO (Section 12 - https://www.apollographql.com/docs/ios/tutorial/tutorial-define-additional-mutations#implement-the-canceltrip-logic)
    }
    
    private func isLoggedIn() -> Bool {
        // TODO (Section 10 - https://www.apollographql.com/docs/ios/tutorial/tutorial-first-mutation#display-the-login-view)
        return false
    }
    
}
