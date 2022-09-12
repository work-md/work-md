![Work::Md](https://raw.githubusercontent.com/work-md/work-md/master/work-md-resized.png)

![](https://img.shields.io/gem/v/work-md?style=social)

# work-md cli
- [x] Keep your work activities organized in markdown by date        
- [x] Easily remember what you did in a specific day            
- [x] Parse your work progress for a week, month or specific days
- [x] Write permanent and private annotations                   
- [x] Organize multiples projects
- [x] Be more productive in your work, keeping sanity in your personal life      
- [x] Get everything under control                 

## Installation

### With Ruby

*Ruby (>= 2.3)* must be installed in your machine, then install `work-md` with:

    $ gem install work-md

## Usage

### Open or create a new work markdown file for today:

    $ work-md t

By default, a work markdown file live in `[YOUR_HOME_DIRECTORY]/work-md/[YEAR]/[MONTH]/[DAY].md`

If no default editor was set in your environment variables `work-md` will prompt you what editor you want to choose.

You can also set the editor directly in the command call:

    $ EDITOR=[YOUR_FAVORITE_EDITOR] work-md

### Open or create a new work markdown file for yesterday:

    $ work-md y

### Open or create a new work markdown file for today and yesterday at same time:

    $ work-md ty

### Open or create a new work markdown file for tomorrow:

    $ work-md to

### Open or create specific date work markdown file(s):

Day 1 from month 5 and year 2000:

    $ work-md o -d=1 -m=5 -y=2000

Day 1, 2 and 3 from the current month and year:

    $ work-md o -d=1,2,3

Day 1 and 2 from month 4 and current year:

    $ work-md o -d=1,2 -m=4    

Day 1 to 25 from month 2 and current year:

    $ work-md o -d=1..25 -m=2    

Day 1 to 25 from month 2 and current year and 1 to 25 from month 2 in 1999:

    $ work-md o -d=1..25 -m=2 and -d=1..25 -m=2 -y=1999

The `-d` argument is required in all cases.

### Open the last file created:

    $ work-md l

And the last 'n' files created:

    $ work-md l 7

### Open or create a new work markdown file for today and open the last file created:

    $ work-md tl

### Parse your work markdown files:

The parse command receive the same query arguments that `open` command receives, but instead of open it parse all the files matching the query, ex:

Day 1 from month 5 and year 2000:

    $ work-md p -d=1 -m=5 -y=2000

Day 1 to 25 from month 2 and current year and 1 to 25 from month 2 in 1999:

    $ work-md p -d=1..25 -m=2 and -d=1..25 -m=2 -y=1999

The `-d` argument is required in all cases.

### Parse the last 'n' work markdown files:

Last 15 days:

    $ work-md pl 15

### Delete your work markdown files:

The query for delete files is the same as `open` and `parse` commands, ex:

Day 1 from month 5 and year 2000:

    $ work-md d -d=1 -m=5 -y=2000

Day 1 to 25 from month 2 and current year and 1 to 25 from month 2 in 1999:

    $ work-md d -d=1..25 -m=2 and -d=1..25 -m=2 -y=1999

The `-d` argument is required in all cases.

### Add permanent annotations:

Sometimes we need to keep permanent annotations (not only for a specific day), so we can:

    $ work-md a

### Configure your preferences:

    $ work-md c

This command creates a `config.yml` file in `[YOUR_HOME_DIRECTORY]/work-md` (or open, if the file already exists)

We can configure `work-md` behaviour adding values in the created file, example:

```yaml
title: Your Name # Title your files
editor: gedit # Your default editor
lang: pt # Your language ('pt', 'en' and 'es' available)
```

### Tags and multiples projects:

We can use the `-tag` argument in any `work-md` command, ex:

    $ work-md t -tag=other_project

It will scope the command to the `other_project` tag, behind the scenes a tag is only a subdirectory in the root `work-md` directory. We can also set the tag with an environment variable named `WORK_MD_TAG`, ex:

    $ WORK_MD_TAG=other_project work-md t

### Aliases:

`work-md t`-> `work-md today`

`work-md y`-> `work-md yesterday`

`work-md ty`-> `work-md tyesterday`

`work-md to`-> `work-md tomorrow`

`work-md l`-> `work-md last`

`work-md tl`-> `work-md tlast`

`work-md p`-> `work-md parse`

`work-md pl`-> `work-md plast`

`work-md o`-> `work-md open`

`work-md d`-> `work-md delete`

`work-md a`-> `work-md annotations`

`work-md c`-> `work-md config`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/work-md/work-md. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/work-md/work-md/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Work::Md project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/work-md/work-md/blob/master/CODE_OF_CONDUCT.md).

