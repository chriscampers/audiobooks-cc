Future Consideration/Dev Notes
- Built using Xcode Version 26.0.1 (17A400)
- Implement a proper image caching policy to improve performance and reduce unnecessary network calls.
- The app currently uses the Listen Notes SPM library for fetching mock data. Consider migrating to a custom URLSession-based client for better testability and flexibility, as the SPM client is not unit-test friendly.
- Favorites should be persisted in a more robust storage solution than UserDefaults — for example, SQLite or Core Data.
- A temporary artificial delay was added to simulate slower network conditions. Search for "DEV NOTE: Delay" in the codebase to locate and remove it.
- The API data models were initially generated using AI to expedite boilerplate setup.
- The shimmer loading effect was sourced from markiv/SwiftUI-Shimmer. https://github.com/markiv/SwiftUI-Shimmer/

