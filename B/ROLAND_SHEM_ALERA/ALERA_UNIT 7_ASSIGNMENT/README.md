#EXPLANATION

E1:I’d change only the source class that config.dart picks and the --dart-define values. The screens, repository, FairEvent model and tiles stay the same, because they only use the EventSource interface.

E2 Values from --dart-define are compiled into the app, so anyone can extract them. A read-only delivery token is safe, since it only reads public content. A token that can write or manage content must never be put here.

E3: The URL, query and header differ, and the JSON parsing differs the most: Contentful uses items, sys.id and fields, while Sanity uses result, _id and flat fields. The getJson call, name, the defaults and building the FairEvent stay the same. Parsing changes most because each CMS has its own JSON shape.

E4: A 401 is mine as the developer (wrong token or permission). A 404 is also mine (wrong URL or content type name). A 500 is the CMS provider’s problem, and the user can only try again later.

E5: It’s a feature, since the user still sees the last events with a banner. But the copy is only in memory, so if the app is closed and reopened with no internet, there is no saved copy and it shows an error.

E6: build() runs on every redraw, so a request there would be sent again each time. With initState it’s sent once when the screen is created, and again only on refresh.

E7: The spinner would disappear immediately, before the CMS answered. The user would see the old list with no sign of loading, and the new events would pop in later.

E8: Z means UTC. toLocal() converts it to the phone’s time zone. In Iloilo (UTC+8), 05:00Z shows as 1:00 PM, and without toLocal() it would show 5:00 AM.