# work_md

Track your work activities, write annotations, recap what you did for a week, month or specific days... and much more!

## Installation

**Ruby > 2** must be installed in your machine, then install `work_md` yourself as:

    $ gem install work_md


## Usage

### Open or create a new work markdown file for today:

    $ work_md

By default, a work markdown file live in `[YOUR_HOME_DIRECTORY]/work_md/[YEAR]/[MONTH]/[DAY].md`

If no default editor was set in your environment variables `work_md` will prompt you what editor you want to choose.

You can also set the editor directly in the command call:

    $ EDITOR=[YOUR_FAVORITE_EDITOR] work_md

### Parse your work markdown files:

Day 1 from month 5 and year 2000:

    $ work_md parse -d=1 -m=5 -y=2000

Day 1, 2 and 3 from the current month and year:
             
    $ work_md parse -d=1,2,3

Day 1 and 2 from month 4 and current year:

    $ work_md parse -d=1,2 -m=4    

### Configure your preferences:

Create a `config.yml` file in `[YOUR_HOME_DIRECTORY]/work_md`:

    $ touch ~/work_md/config.yml
    
Copy and paste the yaml bellow in your config.yml:

```yaml
title: Henrique F. Teixeira # Title of your files
editor: gedit # Your default editor
lang: pt # Your language (only pt and en available)
```

### Aliases:

`work_md today`-> `work_md t` or just `work_md`

`work_md parse`-> `work_md p`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/henriquefernandez/work_md. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/henriquefernandez/work_md/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WorkMd project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/henriquefernandez/work_md/blob/master/CODE_OF_CONDUCT.md).
