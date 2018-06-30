# frozen_string_literal: true

module FakeCapistranoDsl
  def on(*_args)
    yield
  end

  def within(*_args)
    yield
  end

  def release_path; end

  def roles(*_args); end

  def fetch(*_args); end

  def upload!(*_args); end
end

extend FakeCapistranoDsl
