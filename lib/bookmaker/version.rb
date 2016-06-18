module Bookmaker
  module Version
    MAJOR = 0
    MINOR = 8
    PATCH = 0
    BUILD = 'p'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end