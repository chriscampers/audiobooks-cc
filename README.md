Future Consideration/Dev Notes
- Built using Xcode Version 26.0.1 (17A400)
- Implement a proper image caching policy to improve performance and reduce unnecessary network calls.
- Initial implementation of the app used the Listen Notes SPM library for fetching mock data. I didn't like package for a couple reasons, and am open to discussing them. I ended up migrating to a custom URLSession-based client for better testability and flexibility.
- Favorites should be persisted in a more robust storage solution than UserDefaults — for example, SQLite or Core Data.
- A temporary artificial delay was added to simulate slower network conditions. Search for "DEV NOTE: Delay" in the codebase to locate and remove it.
- The API data models were initially generated using AI to expedite boilerplate setup.
- The shimmer loading effect was sourced from markiv/SwiftUI-Shimmer. https://github.com/markiv/SwiftUI-Shimmer/



