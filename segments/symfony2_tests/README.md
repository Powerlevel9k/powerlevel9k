# Symfony2 Tests

## Installation

To use this segment, you need to activate it by adding `symfony2_tests` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

See [Unit Test Ratios](#unit-test-ratios), below.

### Color Customization

You can change the foreground and background color of this segment by setting
```
# Tests Coverage Good
P9K_SYMFONY2_TESTS_TEST_STATS_GOOD_FOREGROUND='red'
P9K_SYMFONY2_TESTS_TEST_STATS_GOOD_BACKGROUND='blue'

# Tests Coverage Average
P9K_SYMFONY2_TESTS_TEST_STATS_AVG_FOREGROUND='red'
P9K_SYMFONY2_TESTS_TEST_STATS_AVG_BACKGROUND='blue'

# Tests Coverage Bad
P9K_SYMFONY2_TESTS_TEST_STATS_BAD_FOREGROUND='red'
P9K_SYMFONY2_TESTS_TEST_STATS_BAD_BACKGROUND='blue'
```

## Quality of Test Ratios

This segment shows a ratio of "real" classes vs test classes in your source
code. This is just a very simple ratio, and does not show your code coverage
or any sophisticated stats. All this does is count your source files and test
files, and calculate the ratio between them. Just enough to give you a quick
overview about the test situation of the project you are dealing with.