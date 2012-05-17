require 'digest/sha2'

module PXHelpers
  module Password
    # generates a new salt and rehashes the password
    def password_encode(password)
      salt = self.salt
      hash = self.hash(password, salt)
      self.store(hash, salt)
    end

    # checks the password against the stored password
    def password_check(password, store)
      hash = self.get_hash(store)
      salt = self.get_salt(store)

      (self.hash(password, salt) == hash)
    end

    protected

    # generates a psuedo-random 64 character string
    def salt
      salt = ''
      64.times { salt << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
      salt
    end

    # generates a 128 character hash
    def hash(password, salt)
      Digest::SHA512.hexdigest("#{password}:#{salt}")
    end

    # mixes the hash and salt together for storage
    def store(hash, salt)
      hash + salt
    end

    # gets the hash from a stored password
    def get_hash(store)
      store[0..127]
    end

    # gets the salt from a stored password
    def get_salt(store)
      store[128..192]
    end
  end
end