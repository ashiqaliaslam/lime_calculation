# Lime Data App Requirements

## Overview

The Lime Data app is a mobile application developed using the Flutter framework. It allows users to track lime consumption data by entering lime weight and the start/end time of each lime consumption event. The app calculates and displays the total lime weight, total duration, and projected lime consumed based on the entered data.

## Features

1. Enter Lime Data
   - [x] Users can enter lime weight and the start/end time of each lime consumption event.
   - [x] Lime weight is entered in tons.
   - [x] Time is entered using a time picker dialog.
   - [x] Lime data is displayed in a list view.
   - [x] Lime data can be added, edited, and deleted.
   - [ ] Lime data is validated to ensure all required fields are filled.

2. Calculate Totals
   - [x] The app calculates and displays the following totals:
     - [x] Total Lime Weight: The sum of all entered lime weights.
     - [x] Total Duration: The sum of durations between the start and end times of each lime consumption event.
     - [x] Projected Lime Consumed: The estimated lime consumption per day based on the total weight and duration.

3. User Interface
   - [ ] The app has a responsive user interface that adapts to different screen sizes.
   - [ ] The app displays the calculated totals in a visually appealing manner.
   - [x] The app provides feedback to users when errors occur, such as exceeding the maximum duration.

4. Detailed Lime Consumption Statistics
   - [ ] The app provides detailed statistics and insights about lime consumption, including:
     - [ ] Average Lime Weight: The average weight of lime consumed per event.
     - [ ] Maximum Lime Weight: The maximum weight of lime consumed in a single event.
     - [ ] Minimum Lime Weight: The minimum weight of lime consumed in a single event.
     - [ ] Average Duration: The average duration of lime consumption events.
     - [ ] Longest Duration: The longest duration of a lime consumption event.
     - [ ] Shortest Duration: The shortest duration of a lime consumption event.

5. Data Visualization
   - [ ] The app visualizes lime consumption data using interactive charts and graphs.
   - [ ] Users can easily understand lime consumption patterns and trends through the visual representation.

6. Reminders and Notifications
   - [ ] The app allows users to set reminders for lime consumption events.
   - [ ] Users receive notifications at the specified time to remind them to consume lime.

7. Data Export and Backup
   - [ ] Users can export lime consumption data to a CSV or Excel file for further analysis or backup purposes.
   - [ ] The app provides an option to backup and restore lime consumption data to/from cloud storage services.

8. Dark Mode Support
   - [ ] The app offers a dark mode option for improved visibility and reduced eye strain in low-light environments.

## Technical Details

- The app is developed using the Flutter framework.
- The main entry point of the app is the `main()` function.
- The app consists of multiple classes:
  - `MyApp`: The root widget of the app, responsible for setting up the theme and displaying the LimeDataForm.
  - `LimeData`: Represents a lime consumption event with weight, start time, and end time.
  - `LimeDataForm`: A form widget that allows users to enter and display lime consumption data.
  - `LimeDataField`: Represents a single lime consumption event in the form.
  - `TimePickerButton`: A reusable widget for selecting a time using a time picker dialog.
  - `LimeConsumption`: A utility class for calculating the duration between start and end times.
  - `DurationWidget`: A widget for displaying a duration.
  - `TextStyles`: Contains predefined text styles used in the app.
- The app uses stateful widgets to manage the state of lime data and perform calculations.
- The app uses various Flutter widgets such as `TextFormField`, `Card`, `ListView.builder`, and `ElevatedButton` to build the user interface.
- The app handles user interactions such as tapping, editing, and deleting lime data using `GestureDetector` and event handlers.
- The app validates user input using form validation and displays error messages when necessary.
- The app utilizes the `DateTime` class to calculate durations between start and end times.
- The app incorporates responsive design principles to ensure a consistent user experience across different screen sizes.

## Dependencies

- The app imports two external packages:
  - `flutter/material.dart`: Provides the necessary widgets for building the app's user interface.
  - `lime_calculation/color_schemes.g.dart`: Contains color schemes used in the app's theme.
