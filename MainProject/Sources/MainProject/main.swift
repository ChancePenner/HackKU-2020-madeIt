import Foundation
import Alamofire

if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
   let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {

  let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
  let parameters = ["From": "+18065471980", "To": "9133134958", "Body": "TESTING"]

  Alamofire.request(url, method: .post, parameters: parameters)
    .authenticate(user: accountSID, password: authToken)
    .responseJSON { response in
      debugPrint(response)
  }

  RunLoop.main.run()
}
