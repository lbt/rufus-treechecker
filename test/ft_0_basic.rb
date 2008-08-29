
#
# Testing rufus-treechecker
#
# jmettraux at gmail.org
#
# Fri Aug 29 10:13:33 JST 2008
#

require 'test/unit'

require 'rubygems'

require 'rufus/treechecker'


class BasicTest < Test::Unit::TestCase

  def assert_ok (tc, rubycode)
    tc.check(rubycode)
  end
  def assert_nok (tc, rubycode)
    assert_raise Rufus::SecurityError do
      tc.check(rubycode)
    end
  end

  def test_0

    tc = Rufus::TreeChecker.new do
      exclude_vcall :abort
      exclude_fcall :abort
      exclude_vcall :exit, :exit!
      exclude_fcall :exit, :exit!
      exclude_call_to :exit
    end

    assert_nok(tc, 'exit')
    assert_nok(tc, 'exit()')
    assert_nok(tc, 'exit!')
    assert_nok(tc, 'abort')
    assert_nok(tc, 'abort()')
    assert_nok(tc, 'Kernel.exit')
    assert_nok(tc, 'Kernel.exit()')
    assert_nok(tc, 'Kernel::exit')
    assert_nok(tc, 'Kernel::exit()')

    assert_ok(tc, '1 + 1')
  end

  def test_0b_vm_exiting

    # TODO : implement me !
  end

  def test_1_global_vars

    tc = Rufus::TreeChecker.new do
      exclude_global_vars
    end

    assert_nok(tc, '$ENV')
    assert_nok(tc, '$ENV = {}')
    assert_nok(tc, "$ENV['HOME'] = 'away'")
  end

  def test_2_aliases

    tc = Rufus::TreeChecker.new do
      exclude_alias
    end

    assert_nok(tc, 'alias :a :b')
  end

  def test_3_exclude_calls_on

    tc = Rufus::TreeChecker.new do
      exclude_call_on :File, :FileUtils
      exclude_call_on :IO
    end

    assert_nok(tc, 'data = File.read("surf.txt")')
    assert_nok(tc, 'f = File.new("surf.txt")')
    assert_nok(tc, 'FileUtils.rm_f("bondzoi.txt")')
    assert_nok(tc, 'IO.foreach("testfile") {|x| print "GOT ", x }')
  end

  def test_4_exclude_def

    tc = Rufus::TreeChecker.new do
      exclude_def
    end

    assert_nok(tc, 'def drink; "water"; end')
    assert_nok(tc, 'class Toto; def drink; "water"; end; end')
  end

  def test_5_exclude_class_tinkering

    tc = Rufus::TreeChecker.new do
      exclude_class_tinkering
    end

    assert_nok(tc, 'class << instance; def length; 3; end; end')
    assert_nok(tc, 'class Toto; end')
    assert_nok(tc, 'class Alpha::Toto; end')
  end

  def test_5b_exclude_class_tinkering_with_exceptions

    tc = Rufus::TreeChecker.new do
      exclude_class_tinkering String, Rufus::TreeChecker
    end

    assert_nok(tc, 'class String; def length; 3; end; end')

    assert_ok(tc, 'class S2 < String; def length; 3; end; end')
    assert_ok(tc, 'class Toto < Rufus::TreeChecker; def length; 3; end; end')

    assert_nok(tc, 'class Toto; end')
    assert_nok(tc, 'class Alpha::Toto; end')
  end

  def test_6_exclude_module_tinkering

    tc = Rufus::TreeChecker.new do
      exclude_module_tinkering
    end

    assert_nok(tc, 'module Alpha; end')
    assert_nok(tc, 'module Momo::Alpha; end')
  end

  def test_7_exclude_eval

    tc = Rufus::TreeChecker.new do
      exclude_eval
    end

    assert_nok(tc, 'eval("code")')
    assert_nok(tc, 'toto.instance_eval("code")')
    assert_nok(tc, 'Toto.module_eval("code")')
  end

  def test_8_exclude_backquotes

    tc = Rufus::TreeChecker.new do
      exclude_backquotes
    end

    assert_nok(tc, '`kill -9 whatever`')
  end

  #class Rufus::TreeChecker
  #  def sexp (rubycode)
  #    puts
  #    puts "\"#{rubycode}\" =>"
  #    p parse(rubycode)
  #  end
  #end
  #def test_X
  #  tc = Rufus::TreeChecker.new do
  #  end
  #  tc.sexp 'raise "error!"'
  #end
end
