import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';

import 'apod_list_fixture.dart';

void main() {
  group('asserting apod list fixture correctnes', () {
    late ApodListFixture fix;

    setUp(() async {
      fix = await ApodListFixture.loadFromMarch();
    });

    test('testing fromRange method', () async {
      final wholeMonth = fix.fromRange(
        DateTimeRange(start: DateTime(2024, 3, 1), end: DateTime(2024, 3, 31)),
      );
      expect(wholeMonth, hasLength(31));
      expect(wholeMonth.first.date, DateTime(2024, 3, 1));
      expect(wholeMonth.last.date, DateTime(2024, 3, 31));

      final tenDays = fix.fromRange(
        DateTimeRange(start: DateTime(2024, 3, 1), end: DateTime(2024, 3, 10)),
      );
      expect(tenDays, hasLength(10));
      expect(tenDays.first.date, DateTime(2024, 3, 1));
      expect(tenDays.last.date, DateTime(2024, 3, 10));

      final threeDays = fix.fromRange(
        DateTimeRange(start: DateTime(2024, 3, 28), end: DateTime(2024, 3, 30)),
      );
      expect(threeDays, hasLength(3));
      expect(threeDays[0].date, DateTime(2024, 3, 28));
      expect(threeDays[1].date, DateTime(2024, 3, 29));
      expect(threeDays[2].date, DateTime(2024, 3, 30));

      final oneDay = fix.fromRange(
        DateTimeRange(start: DateTime(2024, 3, 15), end: DateTime(2024, 3, 15)),
      );
      expect(oneDay, hasLength(1));
      expect(oneDay.single.date, DateTime(2024, 3, 15));
    });

    test('testing fromDate method', () async {
      expect(fix.apods, hasLength(31));

      final apods =
          List.generate(31, (i) => fix.fromDate(DateTime(2024, 3, i + 1)));

      expect(apods[0].title, "Odysseus and The Dish");
      expect(apods[0].date, DateTime(2024, 3, 1));
      expect(apods[0], isA<NasaImage>());
      expect(apods[1].title, "Odysseus on the Moon");
      expect(apods[1].date, DateTime(2024, 3, 2));
      expect(apods[1], isA<NasaImage>());
      expect(apods[2].title, "A Total Solar Eclipse Close-Up in Real Time");
      expect(apods[2].date, DateTime(2024, 3, 3));
      expect(apods[2], isA<NasaVideo>());
      expect(apods[3].title, "Light Pillars Over Inner Mongolia");
      expect(apods[3].date, DateTime(2024, 3, 4));
      expect(apods[3], isA<NasaImage>());
      expect(apods[4].title, "NGC 2170: Angel Nebula Abstract Art");
      expect(apods[4].date, DateTime(2024, 3, 5));
      expect(apods[4], isA<NasaImage>());
      expect(apods[5].title, "M102: Edge-on Disk Galaxy");
      expect(apods[5].date, DateTime(2024, 3, 6));
      expect(apods[5], isA<NasaImage>());
      expect(apods[6].title, "The Crew-8 Nebula");
      expect(apods[6].date, DateTime(2024, 3, 7));
      expect(apods[6], isA<NasaImage>());
      expect(apods[7].title, "The Tarantula Zone");
      expect(apods[7].date, DateTime(2024, 3, 8));
      expect(apods[7], isA<NasaImage>());
      expect(apods[8].title, "Comet Pons-Brooks in Northern Spring");
      expect(apods[8].date, DateTime(2024, 3, 9));
      expect(apods[8], isA<NasaImage>());
      expect(apods[9].title, "A Total Eclipse at the End of the World");
      expect(apods[9].date, DateTime(2024, 3, 10));
      expect(apods[9], isA<NasaImage>());
      expect(apods[10].title, "A Full Plankton Moon");
      expect(apods[10].date, DateTime(2024, 3, 11));
      expect(apods[10], isA<NasaImage>());
      expect(apods[11].title, "A Galaxy-Shaped Rocket Exhaust Spiral");
      expect(apods[11].date, DateTime(2024, 3, 12));
      expect(apods[11], isA<NasaImage>());
      expect(apods[12].title, "The Seagull Nebula");
      expect(apods[12].date, DateTime(2024, 3, 13));
      expect(apods[12], isA<NasaImage>());
      expect(apods[13].title, "Moon Pi and Mountain Shadow");
      expect(apods[13].date, DateTime(2024, 3, 14));
      expect(apods[13], isA<NasaImage>());
      expect(apods[14].title, "Portrait of NGC 1055");
      expect(apods[14].date, DateTime(2024, 3, 15));
      expect(apods[14], isA<NasaImage>());
      expect(apods[15].title, "ELT and the Milky Way");
      expect(apods[15].date, DateTime(2024, 3, 16));
      expect(apods[15], isA<NasaImage>());
      expect(apods[16].title, "NGC 7714: Starburst after Galaxy Collision");
      expect(apods[16].date, DateTime(2024, 3, 17));
      expect(apods[16], isA<NasaImage>());
      expect(apods[17].title, "Comet Pons-Brooks' Swirling Coma");
      expect(apods[17].date, DateTime(2024, 3, 18));
      expect(apods[17], isA<NasaImage>());
      expect(apods[18].title, "A Picturesque Equinox Sunset");
      expect(apods[18].date, DateTime(2024, 3, 19));
      expect(apods[18], isA<NasaImage>());
      expect(apods[19].title, "The Eyes in Markarian's Galaxy Chain");
      expect(apods[19].date, DateTime(2024, 3, 20));
      expect(apods[19], isA<NasaImage>());
      expect(apods[20].title, "The Leo Trio");
      expect(apods[20].date, DateTime(2024, 3, 21));
      expect(apods[20], isA<NasaImage>());
      expect(apods[21].title, "Phobos: Moon over Mars");
      expect(apods[21].date, DateTime(2024, 3, 22));
      expect(apods[21], isA<NasaImage>());
      expect(apods[22].title, "Ares 3 Landing Site: The Martian Revisited");
      expect(apods[22].date, DateTime(2024, 3, 23));
      expect(apods[22], isA<NasaImage>());
      expect(apods[23].title, "Looking Back at an Eclipsed Earth");
      expect(apods[23].date, DateTime(2024, 3, 24));
      expect(apods[23], isA<NasaImage>());
      expect(
          apods[24].title, "Sonified: The Jellyfish Nebula Supernova Remnant");
      expect(apods[24].date, DateTime(2024, 3, 25));
      expect(apods[24], isA<NasaVideo>());
      expect(apods[25].title, "Comet Pons-Brooks' Ion Tail");
      expect(apods[25].date, DateTime(2024, 3, 26));
      expect(apods[25], isA<NasaImage>());
      expect(apods[26].title, "The Coma Cluster of Galaxies");
      expect(apods[26].date, DateTime(2024, 3, 27));
      expect(apods[26], isA<NasaImage>());
      expect(apods[27].title, "Millions of Stars in Omega Centauri");
      expect(apods[27].date, DateTime(2024, 3, 28));
      expect(apods[27], isA<NasaImage>());
      expect(apods[28].title, "Galileo's Europa");
      expect(apods[28].date, DateTime(2024, 3, 29));
      expect(apods[28], isA<NasaImage>());
      expect(apods[29].title, "Medieval Astronomy from Melk Abbey");
      expect(apods[29].date, DateTime(2024, 3, 30));
      expect(apods[29], isA<NasaImage>());
      expect(
          apods[30].title, "Total Solar Eclipse Below the Bottom of the World");
      expect(apods[30].date, DateTime(2024, 3, 31));
      expect(apods[30], isA<NasaImage>());
    });
  });
}
