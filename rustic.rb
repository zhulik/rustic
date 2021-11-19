# frozen_string_literal: true

repository "tmp/repository"

password "password"

before do
  logger.info(self, "BEFORE")
end

backup do
  one_fs!

  before do |exists|
    logger.info(self, "BEFORE BACKUP #{exists}")
  end

  after do
    logger.info(self, "AFTER BACKUP")
  end

  backup "lib"
  exclude "lib/rustic"
end

after do
  logger.info(self, "AFTER")
end

on_error do |error|
  logger.warn(self, "ERROR:", error)
end
