require 'spec_helper'
require 'sugarcrm'

describe 'SugarCrm' do

  subject { Sugarcrm.new() }

  describe 'performing actions' do

    context 'with invalid action' do

      it 'outputs list of valid actions' do

        setup_fake_input('invalid action', 'quit')
        expect do
          subject.launch!
        end.to output(/Action not recognized./).to_stdout
      end

    end

    context 'with quit action' do

      it 'outputs concluding message and exits' do
        setup_fake_input('quit')
        expect{subject.launch!}.to output(/Goodbye/).to_stdout
      end

    end

    context 'with create action' do
      it 'outputs a manifast file' do
        setup_fake_input('create', 'quit')
        output = capture_output { subject.launch! }
        expect(output).to include("CREATE A NEW PACKAGE")
      end
    end

    context 'with create action' do
      it 'outputs a manifast file' do
        setup_fake_input('create', 'quit')
        output = capture_output { subject.launch! }
        expect(output).to include("CREATE A NEW PACKAGE")
      end
    end

  end
end
