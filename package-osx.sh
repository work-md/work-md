# gem
cd packaging && curl -L -O --fail http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20210206-2.4.10-osx.tar.gz
cd ..
mkdir work-md-0.4.91-osx
mkdir work-md-0.4.91-osx/ruby
tar -xzf packaging/traveling-ruby-20210206-2.4.10-osx.tar.gz -C work-md-0.4.91-osx/ruby
cp -r gem work-md-0.4.91-osx/gem

# dependency gems
mkdir packaging/tmp
cp packaging/Gemfile packaging/tmp/Gemfile
cd packaging/tmp
rbenv global 2.4.10
BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development
cd ../..
rm -rf packaging/tmp
rm -f packaging/vendor/*/*/cache/*
cp -r packaging/vendor work-md-0.4.91-osx/vendor
mkdir work-md-0.4.91-osx/vendor/.bundle
cp packaging/bundler-config work-md-0.4.91-osx/vendor/.bundle/config

cp packaging/Gemfile work-md-0.4.91-osx/vendor/Gemfile
cp packaging/Gemfile.lock work-md-0.4.91-osx/vendor/Gemfile.lock

cp packaging/run.sh work-md-0.4.91-osx/work-md
chmod +x work-md-0.4.91-osx/work-md
rm -r packaging/vendor
#rm packaging/Gemfile.lock

# package
# tar -czf work-md-0.4.91-osx.tar.gz work-md-0.4.91-osx && rm -rf work-md-0.4.91-osx
