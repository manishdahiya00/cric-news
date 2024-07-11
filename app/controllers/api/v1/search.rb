module API
  module V1
    class Search < Grape::API
      include API::V1::Defaults

      resource :search do
        params do
          requires :query, type: String, allow_blank: false
        end

        post do
          begin
            res = []
            api_key = "sk-proj-sk1TaxYeY21ewd8GWLa2T3BlbkFJexavcRwZunzfq6tW1E2L"
            require "gemini-ai"
            client = Gemini.new(
              credentials: {
                service: "generative-language-api",
                api_key: "AIzaSyBQFKUUqoMpg6CtkhxR03oKEdJu8nuS1B8",
              },
              options: { model: "gemini-pro", server_sent_events: true },
            )
            response = client.stream_generate_content({
              contents: { role: "user", parts: { text: params[:query] } },
            })

            if response && response[0] && response[0]["candidates"] &&
               response[0]["candidates"][0] && response[0]["candidates"][0]["content"] &&
               response[0]["candidates"][0]["content"]["parts"]
              res << response[0]["candidates"][0]["content"]["parts"][0]["text"] || ""
            else
              res << "No response from AI"
            end

            data = { ans: res }
            { status: 200, message: MSG_SUCCESS, answer: data }
          rescue StandardError => e
            Rails.logger.error "API Exception => #{Time.now} --- searchApi --- Params: #{params.inspect}  Error: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end
    end
  end
end
