class FriendInvitesMailer < ApplicationMailer

  def send_invite(friend_email, friend_name, freelancer)
    @freelancer = freelancer
    @friend_email = friend_email
    @friend_name = friend_name
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.full_name],
            '%friend_name%' => [@friend_name],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '8ecb6507-e653-4bb5-93fa-eca8a8a98213'
                }
            }
        }
    }.to_json
    mail(to: @friend_email, subject: 'You where invited to join the AVJ network')
  end
end

