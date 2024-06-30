# frozen_string_literal: true

repository "tmp/repository"

password "password"

before do
  Console.logger.info(self, "BEFORE")
end

backup do
  one_fs!

  before do |exists|
    Console.logger.info(self, "BEFORE BACKUP #{exists}")
  end

  after do
    Console.logger.info(self, "AFTER BACKUP")
  end

  backup "lib"
  exclude "lib/rustic"
end

after do
  Console.logger.info(self, "AFTER")
end

on_error do |error|
  Console.logger.warn(self, "ERROR:", error)
end
