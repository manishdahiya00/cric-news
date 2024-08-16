module API
  module V1
    class NewsDetails < Grape::API
      include API::V1::Defaults
      resource :newsDetails do
        before { api_params }

        params do
          use :common_params
          requires :newsId, type: String, allow_blank: false
        end
        post do
          begin
            user = UserDetail.find_by(id: params[:userId], security_token: params[:securityToken])
            if user.present?
              news = News.find_by(id: params[:newsId])
              if news.present?
                newsData = {
                  newsId: news.id,
                  newsTitle: news.title,
                  newsContent: news.content,
                  newsDescription: news.description,
                  newsImage: news.image,
                  sourceUrl: news.url,
                  publishedAt: news.published_at.strftime("%d/%m/%y"),
                }
              else
                { status: 500, message: "News Not Found" }
              end
              { status: 200, message: MSG_SUCCESS, newsData: newsData || {} }
            else
              { status: 500, message: "No User Found" }
            end
          rescue Exception => e
            Rails.logger.error "API Exception => #{Time.now} --- newsDetail --- Params: #{params.inspect}  Error: #{e.message}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end
    end
  end
end
