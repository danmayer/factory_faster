require File.expand_path("../test_helper", File.dirname(__FILE__))

class DataStoreTest < Test::Unit::TestCase

  should "load existing data on initialization" do
    setup_sample_file
    store = FactoryFaster::DataStore.new(sample_filename)
    assert_equal 2, store.records.size
  end
  
  should "deserialize skips" do
    setup_sample_file
    store = FactoryFaster::DataStore.new(sample_filename)
    assert_equal [5,12,19,20], store.skips_for("test/unit/foo_test.rb")
  end
  
  should "be able to set skips" do
    setup_sample_file
    File.expects(:read).returns("foo") # MD5 is acbd18db4cc2f85cedef654fccc4a4d8
    store = FactoryFaster::DataStore.new(sample_filename)
    store.set("test/unit/bar_test.rb", [1,2])
    assert_equal [1,2], store.skips_for("test/unit/bar_test.rb")
  end

  private

  def setup_sample_file
    File.open(sample_filename, "w") do |f|
      f.syswrite("test/unit/foo_test.rb|abcdefabcde|5,12,19,20\n")
      f.syswrite("test/unit/bar_test.rb|abcde|\n")
    end
  end

  def sample_filename
    "tmp/factory_faster.txt"
  end

end
