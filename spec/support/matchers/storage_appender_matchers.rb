module StorageAppenderMatchers
  extend ::RSpec::Matchers::DSL

  matcher :append_to  do |appender|
    match do |actual|
      expect(appender).to receive(:append).with(instance_of(::Suspect::Gathering::RunInfo)) do |info|
        @actual_run_info = info
      end

      actual.call

      if @actual_run_info
        erroneous = @expected_run_info_data.select { |attr, value| @actual_run_info.public_send(attr) != value }

        if erroneous.empty?
          true
        else
          @failure_message = "expected #{@actual_run_info} to include #{@expected_run_info_data}"
          false
        end
      else
        true # Mocking for #append handles the failure.
      end
    end

    chain :with do |options|
      @expected_run_info_data = options
    end

    failure_message do
      @failure_message
    end

    def supports_block_expectations?
      true
    end
  end
end