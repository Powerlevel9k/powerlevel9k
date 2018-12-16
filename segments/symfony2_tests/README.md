# Symfony2 Tests

## Installation

To use this segment, you need to activate it by adding `symfony2_tests` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

See [Unit Test Ratios](#unit-test-ratios), below.

## Quality of Test Ratios

This segment shows a ratio of "real" classes vs test classes in your source
code. This is just a very simple ratio, and does not show your code coverage
or any sophisticated stats. All this does is count your source files and test
files, and calculate the ratio between them. Just enough to give you a quick
overview about the test situation of the project you are dealing with.