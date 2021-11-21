#!/bin/env ruby
# frozen_string_literal: true

require "rustic"

Rustic.define do
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

  check do
    before do
      logger.info(self, "BEFORE CHECK")
    end

    after do
      logger.info(self, "AFTER CHECK")
    end
  end

  forget do
    before do
      logger.info(self, "BEFORE FORGET")
    end

    after do
      logger.info(self, "AFTER FORGET")
    end

    prune!
    keep(last: 2, weekly: 2, monthly: 2)
  end

  after do
    logger.info(self, "AFTER")
  end

  on_error do |error|
    logger.warn(self, "ERROR:", error)
  end
end
