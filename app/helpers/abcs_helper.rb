module AbcsHelper
  class Result
    attr_reader :data

    def initialize(header:)
      @data = [[]]
      @date[0] = header
      @num_of_votes = 0
      @choicexs = {}
    end

    def add_choice(title)
      choice_id = @choices.size + 1
      @choices[choice_id]
    end

    def add_vote(vote)
      @votes[vote.name] = vote
    end
  end

  class TotalScorex
    attr_reader :data, :header, :choice_scores, :names, :name, :votes

    def initialize(header)
      @name_index = 0
      @score_index = 1
      @vote_start_index = @score_index + 1
      @vote_index = @vote_start_index

      @header = header
      @votes = {}
      @data = {}
      @initial_score = 0
      @choice_scores = {}
      # @names = Choicex.get_names
      Choicex.name_values.map do |name|
        # choice_id = Choicex.get_choice_id(name)
        @choice_scores[name] ||= @initial_score
        @data[name] ||= []
        @data[name][@name_index] = name
        @data[name][@score_index] = @initial_score
      end
    end

    def add_or_change(vote)
      unless @votes[vote.user_name]
        @header << vote.user_name
        @choice_scores.each_key do |choice_name|
          @data[choice_name][@vote_index] = vote.get_score(choice_name)
        end
        @vote_index += 1
      end
      @votes[vote.user_name] = vote
      @choice_scores.each_key do |choice_name|
        @choice_scores[choice_name] = Choicex.get_total_score(choice_name)
        @data[choice_name][@score_index] = @choice_scores[choice_name]
      end
    end

    def sorted_choices
      @choice_scores.sort_by { |_name, score| score }
    end
  end

  class Choicex
    @logger ||= LoggerUtils.logger()

    @points = []
    @names = {}
    @keys_by_name = {}
    @detailitemx = {}
    @scores = {}
    def self.init(points, names_hash)
      @points = points
      names_hash.each do |key, name|
        @names[key] = name
        @keys_by_name[name] = key
        @scores[key] = 0
      end
    end

    def self.choice_id(name)
      @keys_by_name[name]
    end

    def self.name_values
      @names.values
    end

    def self.name_keys
      @names.keys
    end

    def self.add_or_change_with_choice_id(vote_id, choice_id, order)
      @detailitemx[choice_id] ||= {}
      value = Choicex.get_point(order)
      @detailitemx[choice_id][vote_id] = (value.nil? ? 0 : value)
      @scores[choice_id] = @detailitemx[choice_id].values.sum
    end

    def self.get_point(order)
      @points[order]
    end

    def self.get_score_with_choice_id(vote_id, choice_id)
      x = @detailitemx[choice_id]
      x[vote_id]
    end

    def self.get_score(vote_id, choice_name)
      choice_id = Choicex.get_choice_id(choice_name)
      Choicex.get_score_with_choice_id(vote_id, choice_id)
    end

    def self.get_total_score(choice_name)
      choice_id = Choicex.get_choice_id(choice_name)
      Choicex.get_total_score_with_choice_id(choice_id)
    end

    def self.get_total_score_with_choice_id(choice_id)
      @scores[choice_id]
    end

    def self.show_detailitemx
      @logger.debug @detailitemx
    end
  end

  class Votex
    attr_reader :user_name, :vote_id

    @next_vote_id = 0
    def self.next_vote_id
      next_vote_id = @next_vote_id
      @next_vote_id += 1
      next_vote_id
    end

    def initialize(user_name, vote_result)
      @user_name = user_name
      @vote_id = Votex.next_vote_id
      @vote_result = vote_result
      vote_result.each_with_index do |result, index|
        Choicex.add_or_change_with_choice_id(@vote_id, result, index)
      end
    end

    def get_score(choice_name)
      Choicex.get_score(@vote_id, choice_name)
    end
  end
end
