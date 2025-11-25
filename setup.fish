function setup
    if test (count $argv) -lt 1
        echo "Usage: setup <redis|minio|base>"
        return 1
    end
    
    set target $argv[1]

    if test "$target" = "base"
        set template_dir ~/.dev_utils/templates/python/

        for file in .env.base .gitignore .dockerignore Dockerfile docker-compose.yml.base_web_app
            set src "$template_dir$file"

            if not test -f $src
                echo "Missing template: $src"
                continue
            end

            cp $src "./$file"
            echo "Copied: $file"
        end
				uv init
				uv add alembic fastapi sqlalchemy asyncpg psycopg2-binary
				uv run alembic init migrations
				mv .env.base .env
				mv docker-compose.yml.base_web_app docker-compose.yml
				mkdir app
				mv main.py app/

    else
        set src_file ~/.dev_utils/templates/python/docker-compose.yml.$target

        if not test -f $src_file
            echo "Template not found: $src_file"
            return 1
        end

        set dst_file docker-compose.yml.$target
        cp $src_file "./$dst_file"
        echo "Copied: $dst_file"
    end
end
