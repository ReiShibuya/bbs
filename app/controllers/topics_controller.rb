class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.save
    # TODO: スレたてと同時にコメントも投稿させる目論見だが、もうちょい改良できそう
    @comment = @topic.comments.build(comment_params)
    @comment.save
    flash[:notice] = '新しいスレッドを立てました'
    redirect_to @topic
  end

  # TODO: バリデーションの挙動を追加

  def show
    @topic = Topic.find(params[:id])
  end

  private
    def topic_params
      params.require(:topic).permit(:title)
    end

    def comment_params
      params.require(:topic).permit(:name, :content)
    end
end
