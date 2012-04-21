# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CrhanGit::Application.initialize!

require File.join(Rails.root, "lib", "crhanGit", "crhan_git")
