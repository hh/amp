module Amp
  module Repositories
    
    ##
    # = CommonVersionedFileMethods
    #
    # These methods are common to all repositories, and this module is mixed into
    # the AbstractLocalRepository class. This guarantees that all repositories will
    # have these methods.
    #
    # No methods should be placed into this module unless it relies on methods in the
    # general API for repositories.
    module CommonChangesetMethods
      ##
      # A hash of the files that have been changed and their most recent diffs.
      # The diffs are lazily made upon access. To just get the files, use #altered_files
      # or #changed_files.keys
      # Checks whether this changeset included a given file or not.
      # 
      # @return [Hash<String => String>] a hash of {filename => the diff}
      def changed_files
        h = {}
        class << h
          def [](*args)
            super(*args).call # we expect a proc
          end
        end
        
        altered_files.inject(h) do |s, k|
          s[k] = proc do
            other = parents.first[k]
            self[k].unified_diff other
          end
        end
      end
      # @param [String] file the file to lookup
      # @return [Boolean] whether the file is in this changeset's manifest
      def include?(file)
        all_files.include? file
      end
      
    end
  end
end
