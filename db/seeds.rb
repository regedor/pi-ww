# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

AdminUser.create!(email: ENV["SUPER_ADMIN_EMAIL"], password: ENV["SUPER_ADMIN_PASSWORD"], password_confirmation: ENV["SUPER_ADMIN_PASSWORD"]) if Rails.env.development?

# Helper method to read the image and convert it to binary
def read_image_as_binary(file_path)
  File.open(file_path, "rb") { |file| file.read }
end

if Rails.env.development?
  text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. #PI #MEI #UMINHO"

  # Add the paths for your images
  image_files = [
    Rails.root.join('db', 'images', 'sample1.jpg'),
    Rails.root.join('db', 'images', 'sample2.jpg'),
    Rails.root.join('db', 'images', 'sample3.jpg'),
    Rails.root.join('db', 'images', 'sample4.jpg'),
    Rails.root.join('db', 'images', 'sample5.jpg')
  ]

  puts "Creating Social Platforms"
  1.upto(5) do |sp|
    puts "Creating Social Platform #{sp}"
    Socialplatform.find_or_create_by!(name: "Yap#{sp}", link: "https://Yap/#{sp}.pt/", link_form: "https://Yap/form/#{sp}.pt/")
  end

  puts "Creating Organizations and related data"
  1.upto(5) do |o|
    puts "Creating Org #{o}:"
    organization = Organization.find_or_create_by!(name: "Org #{o}")

    # Create 5 users for each org, 2 leaders, 3 normal users
    puts "- Users: "
    1.upto(2) do |n|
      User.create!(email: "user#{n}_#{o}@ww.com", password: "1234567", password_confirmation: "1234567", isLeader: true, organization_id: organization.id)
    end
    3.upto(5) do |n|
      User.create!(email: "user#{n}_#{o}@ww.com", password: "1234567", password_confirmation: "1234567", isLeader: false, organization_id: organization.id)
    end
    puts "Users created."

    # Create 5 calendars for each org
    1.upto(5) do |c|
      puts " - Calendar #{c}"
      calendar = Calendar.find_or_create_by!(name: "Calendar #{c}", organization_id: organization.id)

      # Create 5 posts for each calendar
      1.upto(5) do |p|
        puts "   - Creating Post #{p}"
        uid = p.even? ? 1 : 2
        categories = ("a".."c").to_a # Categories as ["a", "b", "c"]
        post = Post.create!(
          title: "Post #{p}",
          user_id: uid,
          design_idea: text,
          calendar: calendar,
          publish_date: Time.zone.parse('2027-07-11 21:00'),
          status: "in_analysis",
          categories: categories
        )

        # Create 5 comments for each post
        1.upto(5) do |u|
          Comment.create!(content: text, post: post, user_id: u)
        end

        # Create 5 perspectives for each post
        1.upto(5) do |perspective_num|
          puts "     - Creating Perspective #{perspective_num}"
          perspective = Perspective.create!(copy: "Perspective #{perspective_num} for post #{p}", post: post, socialplatform_id: Socialplatform.first.id)

          # Create 5 attachments for each perspective with real image content
          1.upto(5) do |attachment_num|
            puts "       - Creating Attachment #{attachment_num}"
            image_file_path = image_files[attachment_num % image_files.size]  # Cycle through the image files
            image_binary = read_image_as_binary(image_file_path)

            Attachment.create!(filename: File.basename(image_file_path), content: image_binary, perspective: perspective)
          end
        end
      end
    end
  end
end

puts "Seeding complete."
