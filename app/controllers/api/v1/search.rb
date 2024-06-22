module API
  module V1
    class Search < Grape::API
      include API::V1::Defaults

      #####################################################################
      #############  ====>             Search API
      #####################################################################

      resource :search do
        params do
          # use :common_params
          requires :query, type: String, allow_blank: false
        end
        post do
          begin
            res = []
            api_key = 'sk-proj-sk1TaxYeY21ewd8GWLa2T3BlbkFJexavcRwZunzfq6tW1E2L'
            require 'gemini-ai'
            client = Gemini.new(
              credentials: {
                service: 'generative-language-api',
                api_key: 'AIzaSyBQFKUUqoMpg6CtkhxR03oKEdJu8nuS1B8'
              },
              options: { model: 'gemini-pro', server_sent_events: true }
            )

            response = client.stream_generate_content({
              contents: { role: 'user', parts: { text: params[:query] } }
            })
            res << response[0]["candidates"][0]["content"]["parts"][0]["text"]
            data = {ans:res}
            {status: 200, message: MSG_SUCCESS, answer: data || []}
          rescue StandardError => e
            Rails.logger.error "API Exception => #{Time.now} --- searchApi --- Params: #{params.inspect}  Error: #{e.message}"
            {status: 500, message: MSG_ERROR, error: e}
          end
        end
      end
    end
  end
end
