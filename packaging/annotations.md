if the environment isnt prepared
  1. install ruby 2.4.10
  2. gem install bundler -v 1.17.3
3. manually populate packaging/Gemfile
4. manually add this in in the end of generated vendor/Gemfile.lock:

BUNDLED WITH
   1.17.3

5. Update README with newer versions, following the template:

### From binaries

#### Linux users

Run the following commands:

    $ curl -L -o work-md-0.4.9.tar.gz https://github.com/work-md/work-md/raw/master/work-md-0.4.9-linux-x86_64.tar.gz |
    $ tar -xzf work-md-0.4.9.tar.gz
    $ cd work-md-0.4.9-linux-x86_64
    $ ./work-md

#### OSx users

Run the following commands:

    $ curl -L -o work-md-0.4.9.tar.gz https://github.com/work-md/work-md/raw/master/work-md-0.4.9-linux-x86_64.tar.gz |
    $ tar -xzf work-md-0.4.9.tar.gz
    $ cd work-md-0.4.9-linux-x86_64
    $ ./work-md

