![WorkMd](https://raw.githubusercontent.com/henriquefernandez/work_md/master/logo-resized.png)

![](https://img.shields.io/gem/v/work_md?style=social)

Track your work activities, write annotations, recap what you did for a week, month or specific days... and much more!

## Installation

*Ruby (>= 2.3)* must be installed in your machine, then install `work_md` with:

    $ gem install work_md

## Usage

### Open or create a new work markdown file for today:

    $ work_md t

By default, a work markdown file live in `[YOUR_HOME_DIRECTORY]/work_md/[YEAR]/[MONTH]/[DAY].md`

If no default editor was set in your environment variables `work_md` will prompt you what editor you want to choose.

You can also set the editor directly in the command call:

    $ EDITOR=[YOUR_FAVORITE_EDITOR] work_md

### Open or create a new work markdown file for yesterday:

    $ work_md y

### Open or create a new work markdown file for today and yesterday at same time:

    $ work_md ty

### Parse your work markdown files:

Day 1 from month 5 and year 2000:

    $ work_md p -d=1 -m=5 -y=2000

Day 1, 2 and 3 from the current month and year:
             
    $ work_md p -d=1,2,3

Day 1 and 2 from month 4 and current year:

    $ work_md p -d=1,2 -m=4    

Day 1 to 25 from month 2 and current year:

    $ work_md p -d=1..25 -m=2    

### Configure your preferences:

    $ work_md c

This command creates a `config.yml` file in `[YOUR_HOME_DIRECTORY]/work_md` (or open, if the file already exists)

We can configure `work_md` behaviour adding values in the created file, example:

```yaml
title: Your Name # Title your files
editor: gedit # Your default editor
lang: pt # Your language ('pt', 'en' and 'es' available)
```

### Aliases:

`work_md t`-> `work_md today`

`work_md y`-> `work_md yesterday`

`work_md ty`-> `work_md tyesterday`

`work_md p`-> `work_md parse`

`work_md c`-> `work_md config`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/henriquefernandez/work_md. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/henriquefernandez/work_md/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WorkMd project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/henriquefernandez/work_md/blob/master/CODE_OF_CONDUCT.md).
