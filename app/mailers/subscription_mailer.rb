class SubscriptionMailer < ApplicationMailer
  def notice_company_subscribed_to_plan(company, plan)
    @company = company
    @plan = plan
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%plan_name%' => [@plan.name],
            '%root_url%' => [root_url],
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '032be3d6-ff9a-4d5a-813f-250a96392803'
                }
            }
        }
    }.to_json
    mail(to: @company.owner.email, subject: "Subscribed to plan")
  end

  def notice_company_subscription_canceled(company, plan)
    @company = company
    @plan = plan
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%plan_name%' => [@plan.name],
            '%root_url%' => [root_url],
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'e99229d7-a663-4af9-8280-b5b02101c124'
                }
            }
        }
    }.to_json
    mail(to: @company.owner.email, subject: "Subscription canceled")
  end
end
