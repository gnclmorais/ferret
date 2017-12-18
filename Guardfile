# Guardfile
# More info at https://github.com/guard/guard#readme

# Ruby on Rails lazy loads gems as needed in its test suite.
# As a result Guard::Minitest may not be able to run all tests
# until the gem dependencies are resolved.
# To solve the issue either add the missing dependencies or remove the tests.

guard :minitest, all_on_start: false do
  watch(%r{^app/(.+)\.rb$})            { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.+)_mailer/.+}) { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^lib/(.+)\.rb$})            { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^lib/tasks/(.+)\.rake$})    { |m| "test/lib/tasks/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
end
