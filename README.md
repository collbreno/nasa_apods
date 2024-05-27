# nasa_apod

## Running project
This project uses [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) for storing API key securely. In order to run the app properly, you have to create a `.env` file in the root folder and define the API key to access NASA API:
```properties
# .env
API_KEY=<YOUR_API_KEY_HERE>
```
Finally, you just need to run it like any Flutter project:
```bash
flutter pub get
flutter run
```

## Screenshots
### Dark mode
<div style="display: flex; justify-content: space-between;">
  <img src="./screenshots/dark1.png?raw=true" alt="Screenshot 1 from Dark mode" width="200"/>
  <img src="./screenshots/dark2.png?raw=true" alt="Screenshot 2 from Dark mode" width="200"/>
  <img src="./screenshots/dark3.png?raw=true" alt="Screenshot 3 from Dark mode" width="200"/>
  <img src="./screenshots/dark4.png?raw=true" alt="Screenshot 4 from Dark mode" width="200"/>
</div>


### Light mode
<div style="display: flex; justify-content: space-between;">
  <img src="./screenshots/light1.png?raw=true" alt="Screenshot 1 from Light mode" width="200"/>
  <img src="./screenshots/light2.png?raw=true" alt="Screenshot 2 from Light mode" width="200"/>
  <img src="./screenshots/light3.png?raw=true" alt="Screenshot 3 from Light mode" width="200"/>
  <img src="./screenshots/light4.png?raw=true" alt="Screenshot 4 from Light mode" width="200"/>
</div>
