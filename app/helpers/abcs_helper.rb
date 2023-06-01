module AbcsHelper
    class Result
        attr_reader :data
        def initialize(header: )
            @data = [[]]
            @date[0] = header
            @num_of_votes = 0
            @choicexs = {}
        end

        def add_choice(title)
            choice_id = @choices.zie + 1
            @choices[choicex.choice_id]
        end

        def add_vote(vote)
            @votes[vote.name] = vote
        end
    end

    class TotalScorex
        attr_reader :data, :header

        def initialize(header)
            @header = header
            @votes = {}
            @choice_scores = {}
            @data = {}
            @initial_score = 0
            @name_index = 0
            @score_index = 1
            @vote_start_index = @score_index + 1
            @vote_index = @vote_start_index
            Choicex.get_names.map{ |name| 
                @choice_scores[name] = 0
                @data[name] = [] 
                @data[name][@name_index] = name 
                @data[name][@score_index] = @initial_score
            }
        end
        def add_or_change(vote)
            if !@votes[vote.name]
                @header << vote.name
                @choice_scores.keys.each do |choice_name|
                    @data[choice_name][@vote_index] = vote.get_score(choice_name)
                end
                @vote_index += 1
            end
            @votes[vote.name] = vote
            @choice_scores.keys.each do |choice_name|
                @data[choice_name][@score_index] = @data[choice_name][@vote_start_index, @choice_scores.size].inject(:+)
                @choice_scores[choice_name] = @data[choice_name][@score_index]
            end
        end
            
        def get_score(choice_name)
            @choice_scores[choice_name]
        end

        def get_sorted_choices
            @choice_scores.sort_by{ |name, score| score }
        end
    end

    class Votex
        def initialize(id, user_name)
            @id = id
            @user_name = user_name
        end
    end


    class Choicex
        @points = []
        @next_choice_id = 0
        def self.init(points)
            @points = points
        end
        def self.get_score(order)
            @points[order]
        end
        def get_next_choice_id
            @next_choice_id
        end
        def count_up_next_choice_id
            @next_choice_id += 1
        end
        def initialize(title)
            count_up_next_choice_id
            @title = title
            @score = 0
            @choice_id = Choice.get_next_choice_id
            Choice.count_up_next_choice_id

            @detailitemx = {}
        end

        def add_or_change(vote_id, order)
            @detailitemx[vote_id] = get_score(order)
            @score = @detailitemx.values.sum
        end
    end

    class Choicedetailitemx
        attr_reader :score
        def initialize(order)
            # @score = Choicex.get_score[order]
            @score = 0
            change(order)
        end
        def change(order)
            @score = Choicex.get_score(order)
        end
    end

    class Choicedetailx
        def initialize(names:)
            index = 0
            @itemxs = {}
            @names = {}
            while index < @names.size
                name = names[index]
                @names[index] = name
                @itemxs[name] = Choicedetailitemx.new(index)
            end
        end

        def reorder(orders:)
            orders.each_with_index{ |n, idx|
                name = @names[n]
                @itemxs[name].change(name, idx)
            }
        end
    end

    class Votex
        attr_reader :choicex, :name

        def initialize(name , vote_result)
            @name = name
            @vote_result = vote_result
            @choicex = Choicex.new()
            @choicex.change(vote_result)
        end

        def change(vote_result)
            @choicex.change(vote_result)
        end

        def get_score(name)
            @choicex.get_score(name)
        end
    end
end
