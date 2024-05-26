# nasa_apod

## Running project
This project uses [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) for storing API key securely. In order to run the app properly, you have to create a `.env` file in the root folder and define the API key to access NASA API:
```properties
# .env
API_KEY=<YOUR_API_KEY_HERE>
```
Finally, you just need to run it like any Flutter project:
```bash
flutter run
```