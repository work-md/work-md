# gem
cd packaging && curl -L -O --fail http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20210206-2.4.10-osx.tar.gz
cd ..
mkdir work_md-0.3.1-osx
mkdir work_md-0.3.1-osx/ruby
tar -xzf packaging/traveling-ruby-20210206-2.4.10-osx.tar.gz -C work_md-0.3.1-osx/ruby
cp -r gem work_md-0.3.1-osx/gem

# dependency gems
mkdir packaging/tmp
cp Gemfile packaging/tmp/
cd packaging/tmp
rbenv global 2.4.10
BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development
cd ../..
rm -rf packaging/tmp
rm -f packaging/vendor/*/*/cache/*
cp -r packaging/vendor work_md-0.3.1-osx/vendor
mkdir work_md-0.3.1-osx/vendor/.bundle
cp packaging/bundler-config work_md-0.3.1-osx/vendor/.bundle/config

cp packaging/Gemfile work_md-0.3.1-osx/vendor/Gemfile
cp packaging/Gemfile.lock work_md-0.3.1-osx/vendor/Gemfile.lock

cp packaging/run.sh work_md-0.3.1-osx/work_md
chmod +x work_md-0.3.1-osx/work_md
rm -r vendor
rm packaging/Gemfile.lock

#cp packaging/wrapper.sh hello-1.0.0-linux-x86/hello
#cp packaging/wrapper.sh hello-1.0.0-linux-x86_64/hello
#cp packaging/wrapper.sh hello-1.0.0-osx/hello

#tar -czf hello-1.0.0-linux-x86.tar.gz hello-1.0.0-linux-x86
#tar -czf hello-1.0.0-linux-x86_64.tar.gz hello-1.0.0-linux-x86_64
#tar -czf hello-1.0.0-osx.tar.gz hello-1.0.0-osx
#rm -rf hello-1.0.0-linux-x86
#rm -rf hello-1.0.0-linux-x86_64
#rm -rf hello-1.0.0-osx
