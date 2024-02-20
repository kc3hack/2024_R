class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)
        root_path # サインイン後, root_pathに遷移
      end
    
      def after_sign_out_path_for(resource)
        root_path # サインアウト後, root_pathに遷移
      end
end
