# gem
cd packaging && curl -L -O --fail http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20210206-2.4.10-linux-x86_64.tar.gz
cd ..
mkdir work_md-0.3.3-linux-x86_64
mkdir work_md-0.3.3-linux-x86_64/ruby
tar -xzf packaging/traveling-ruby-20210206-2.4.10-linux-x86_64.tar.gz -C work_md-0.3.3-linux-x86_64/ruby
cp -r gem work_md-0.3.3-linux-x86_64/gem

# dependency gems
mkdir packaging/tmp
cp Gemfile packaging/tmp/
cd packaging/tmp
rbenv global 2.4.10
BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development
cd ../..
rm -rf packaging/tmp
rm -f packaging/vendor/*/*/cache/*
cp -r packaging/vendor work_md-0.3.3-linux-x86_64/vendor
mkdir work_md-0.3.3-linux-x86_64/vendor/.bundle
cp packaging/bundler-config work_md-0.3.3-linux-x86_64/vendor/.bundle/config

cp packaging/Gemfile work_md-0.3.3-linux-x86_64/vendor/Gemfile
cp packaging/Gemfile.lock work_md-0.3.3-linux-x86_64/vendor/Gemfile.lock

cp packaging/run.sh work_md-0.3.3-linux-x86_64/work_md
chmod +x work_md-0.3.3-linux-x86_64/work_md
rm -r vendor
rm packaging/Gemfile.lock

# package
tar -czf work_md-0.3.3-linux-x86_64.tar.gz work_md-0.3.3-linux-x86_64
rm -rf work_md-0.3.3-linux-x86_64