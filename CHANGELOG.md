### next

* TODO: Replace this bullet point with an actual description of a change.

### 2.7.0 (19 January 2026)

* TODO: Replace this bullet point with an actual description of a change.

### 2.6.0 (7 January 2026)

* Upgraded to Ubuntu 24.04 on Github Actions ([#23](https://github.com/hausgold/keyless/pull/23))
* Migrated to hausgold/actions@v2 ([#22](https://github.com/hausgold/keyless/pull/22))

### 2.5.0 (26 December 2025)

* Added Ruby 4.0 support ([#21](https://github.com/hausgold/keyless/pull/21))
* Dropped Ruby 3.2 and Rails 7.1 support ([#20](https://github.com/hausgold/keyless/pull/20))

### 2.4.0 (19 December 2025)

* Migrated to a shared Rubocop configuration for HAUSGOLD gems ([#19](https://github.com/hausgold/keyless/pull/19))

### 2.3.0 (16 December 2025)

* Switched from `httparty` to the `http` gem and added support for retries on
  the RSA remote fetching (5 times by default) ([#18](https://github.com/hausgold/keyless/pull/18))

### 2.2.0 (2 December 2025)

* Loosend up the version requirement for the `jwt` gem to `>= 2.6`, so people
  can [migrate to
  3.0+](https://github.com/jwt/ruby-jwt/blob/v3.1.2/UPGRADING.md) ([#17](https://github.com/hausgold/keyless/pull/17))

### 2.1.0 (23 October 2025)

* Dropped Reek ([#14](https://github.com/hausgold/keyless/pull/14))
* Added support for Rails 8.1 ([#15](https://github.com/hausgold/keyless/pull/15))
* Switched from `ActiveSupport::Configurable` to a custom implementation based
  on `ActiveSupport::OrderedOptions` ([#16](https://github.com/hausgold/keyless/pull/16))

### 2.0.0 (28 June 2025)

* Corrected some RuboCop glitches ([#12](https://github.com/hausgold/keyless/pull/12))
* Drop Ruby 2 and end of life Rails (<7.1) ([#13](https://github.com/hausgold/keyless/pull/13))

### 1.7.1 (21 May 2025)

* Corrected some RuboCop glitches ([#10](https://github.com/hausgold/keyless/pull/10))
* Upgraded the rubocop dependencies ([#11](https://github.com/hausgold/keyless/pull/11))

### 1.7.0 (30 January 2025)

* Added all versions up to Ruby 3.4 to the CI matrix ([#9](https://github.com/hausgold/keyless/pull/9))

### 1.6.1 (17 January 2025)

* Added the logger dependency ([#8](https://github.com/hausgold/keyless/pull/8))

### 1.6.0 (11 January 2025)

* Switched to Zeitwerk as autoloader ([#7](https://github.com/hausgold/keyless/pull/7))

### 1.5.0 (3 January 2025)

* Raised minimum supported Ruby/Rails version to 2.7/6.1 ([#6](https://github.com/hausgold/keyless/pull/6))

### 1.4.0 (4 October 2024)

* Upgraded the `recursive-open-struct` gem to `~> 2.0` ([#5](https://github.com/hausgold/keyless/pull/5))

### 1.3.5 (15 August 2024)

* Just a retag of 1.3.1

### 1.3.4 (15 August 2024)

* Just a retag of 1.3.1

### 1.3.3 (15 August 2024)

* Just a retag of 1.3.1

### 1.3.2 (9 August 2024)

* Just a retag of 1.3.1

### 1.3.1 (9 August 2024)

* Added API docs building to continuous integration ([#4](https://github.com/hausgold/keyless/pull/4))

### 1.3.0 (8 July 2024)

* Moved the development dependencies from the gemspec to the Gemfile ([#2](https://github.com/hausgold/keyless/pull/2))
* Dropped support for Ruby <2.7 ([#3](https://github.com/hausgold/keyless/pull/3))

### 1.2.0 (24 February 2023)

* Added support for Gem release automation

### 1.1.0 (18 January 2023)

* Bundler >= 2.3 is from now on required as minimal version ([#1](https://github.com/hausgold/keyless/pull/1))
* Dropped support for Ruby < 2.5 ([#1](https://github.com/hausgold/keyless/pull/1))
* Dropped support for Rails < 5.2 ([#1](https://github.com/hausgold/keyless/pull/1))
* Updated all development/runtime gems to their latest
  Ruby 2.5 compatible version ([#1](https://github.com/hausgold/keyless/pull/1))

### 1.0.2 (15 October 2021)

* Migrated to Github Actions
* Migrated to our own coverage reporting
* Added the code statistics to the test process

### 1.0.1 (1 September 2020)

* Renamed the Gem to `keyless`.

### 1.0.0 (28 August 2020)

* Initial release, extracted from former
  [grape-jwt-authentication](https://github.com/hausgold/grape-jwt-authentication)
  code at v1.3.0.
