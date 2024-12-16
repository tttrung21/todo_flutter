#!/bin/bash

flutter doctor
flutter clean
flutter pub get
#flutter pub global run intl_utils:generate
flutter build apk --release