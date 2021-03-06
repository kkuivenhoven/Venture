class BlogsController < ApplicationController

	def index
		@blogs = Blog.all
	end

	def show
		@blog = Blog.find(params[:id])
		@hash_tags = @blog.hash_tags.in_groups(3)
	end

	def new
		@blog = Blog.new
	end

	def create
		@blog = Blog.new(blog_params)
		@hash_tags = params["blog"]["hash_tags"].split(",")
		@hash_tags.each do |hash_tag|
			if HashTag.where(name: hash_tag).count != 0
				@blog.hash_tags << HashTag.where(name: hash_tag)
			else
				@blog.hash_tags << HashTag.new(name: hash_tag)
			end
		end
		if @blog.save
			redirect_to :action => 'index'
		else
			render :action => 'new'
		end
	end

	def edit
		@blog = Blog.find(params[:id])
	end

	def update
		@blog = Blog.find(params[:id])
		@hash_tag_ids = params["blog"]["hash_tag_ids"]
		@blog.update(title: params[:blog][:title], post: params[:blog][:post])
		redirect_to :action => 'index'
	end

	def destroy
		@blog = Blog.find(params[:id])
		@blog.hash_tags.destroy_all
		@blog.destroy
		redirect_to root
		# Blog.destroy(params[:id])
		# redirect_to blogs_path
	end

	private
		
		def blog_params
			params.require(:blog).permit(:title, :post)
		end

end
