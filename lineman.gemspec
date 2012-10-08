Gem::Specification.new do |s|
  s.name = 'lineman'
  s.version = '0.9.0'
  s.date = '2012-10-07'

  s.summary = 'A test runner (UI) for test-unit'
  s.description = 'Lineman provides clean output for your tests, giving you one line for each test that shows the name along with some statistics.'

  s.authors = ['Todd Willey (xtoddx)']
  s.email = 'xtoddx@gmail.com'
  s.homepage = 'http://github.com/xtoddx/lineman'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc]

  s.add_dependency('test-unit', '~> 2.4')

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,tests}/*`.split("\n")
end
