# gem
cd packaging && curl -L -O --fail http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20210206-2.4.10-win32-x86_64.tar.gz
cd ..
mkdir work-md-0.4.9-win32-x86_64
mkdir work-md-0.4.9-win32-x86_64/ruby
tar -xzf packaging/traveling-ruby-20210206-2.4.10-win32-x86_64.tar.gz -C work-md-0.4.9-win32-x86_64/ruby
cp -r gem work-md-0.4.9-win32-x86_64/gem

# dependency gems
mkdir packaging/tmp
cp packaging/Gemfile packaging/tmp/Gemfile
cd packaging/tmp
rbenv global 2.4.10
BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development
cd ../..
rm -rf packaging/tmp
rm -f packaging/vendor/*/*/cache/*
cp -r packaging/vendor work-md-0.4.9-win32-x86_64/vendor
mkdir work-md-0.4.9-win32-x86_64/vendor/.bundle
cp packaging/bundler-config work-md-0.4.9-win32-x86_64/vendor/.bundle/config

cp packaging/Gemfile work-md-0.4.9-win32-x86_64/vendor/Gemfile
cp packaging/Gemfile.lock work-md-0.4.9-win32-x86_64/vendor/Gemfile.lock

cp packaging/run.bat work-md-0.4.9-win32-x86_64/work-md
chmod +x work-md-0.4.9-win32-x86_64/work-md
rm -r packaging/vendor
#rm packaging/Gemfile.lock

# package
# zip -9r work-md-0.4.9-win32-x86_64.zip work-md-0.4.9-win32-x86_64 && rm -rf work-md-0.4.9-win32-x86_64
