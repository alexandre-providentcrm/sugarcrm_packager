
def no_output(&block)
  original_stdout = $stdout.dup
  $stdout.reopen('/dev/null')
  $stdout.sync = true
  begin
    yield
  ensure
    $stdout.reopen(original_stdout)
  end
end

def capture_output(&block)
  original_stdout = $stdout.dup
  output_catcher = StringIO.new
  $stdout = output_catcher
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  output_catcher.string
end

def setup_fake_input(*args)
  allow(Readline).to receive(:readline).and_return(*args)
end

def remove_created_file(file_path)
  if file_path && File.exists?(file_path)
    File.delete(file_path)
  end
end