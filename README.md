# Sambag
Android Time, Month-Year, and Date pickers implemented in Swift for iOS development

## Date Picker

Specifying min and max date

```swift
let vc = SambagDatePickerViewController()
var limit = SambagSelectionLimit()
limit.selectedDate = Date()
let calendar = Calendar.current
limit.minDate = calendar.date(
    byAdding: .year,
    value: -50,
    to: limit.selectedDate,
    wrappingComponents: false
)
limit.maxDate = calendar.date(
    byAdding: .year,
    value: 50,
    to: limit.selectedDate,
    wrappingComponents: false
)
vc.limit = limit
```

Showing day of week

```swift
let vc = SambagDatePickerViewController()
vc.hasDayOfWeek = true 
```

Hiding day of week

```swift
let vc = SambagDatePickerViewController()
vc.hasDayOfWeek = false 
```

## Screenshots

### Time Picker

|||
|---|---|
|![Theme_Dark](https://raw.githubusercontent.com/mownier/sambag/master/Screenshots/theme_dark.png)| ![Theme_Light](https://raw.githubusercontent.com/mownier/sambag/master/Screenshots/theme_light.png)|  

### Month Year Picker

|||
|---|---|
|![Month_Year_Dark](https://raw.githubusercontent.com/mownier/sambag/master/Screenshots/month_year_dark.png) | ![Month_Year_Light](https://raw.githubusercontent.com/mownier/sambag/master/Screenshots/month_year_light.png)|

### Date Picker

|||
|---|---|
|![Date_Dark](https://raw.githubusercontent.com/mownier/sambag/master/Screenshots/date_picker_dark.png) | ![Date_Light](https://raw.githubusercontent.com/mownier/sambag/master/Screenshots/date_picker_light.png)|
