#!/bin/env ruby
# frozen_string_literal: true

require "rustic"

Rustic.define do # rubocop:disable Metrics/BlockLength
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

  check do
    before do
      Console.logger.info(self, "BEFORE CHECK")
    end

    after do
      Console.logger.info(self, "AFTER CHECK")
    end
  end

  forget do
    before do
      Console.logger.info(self, "BEFORE FORGET")
    end

    after do
      Console.logger.info(self, "AFTER FORGET")
    end

    prune!
    keep(last: 2, weekly: 2, monthly: 2)
  end

  after do
    Console.logger.info(self, "AFTER")
  end

  on_error do |error|
    Console.logger.warn(self, "ERROR:", error)
  end
end
