# Lossless Neuro Evolution

The following is an ontological discussion about models of knowledge. For the actual work please refer to **Oezmen_ABM_final_report.pdf** 


# What is an AI model not?

## What is an AI model

To understand what lacks with the mainstream AI models, we must first define what is an AI model. And before that, we must define what we expect it to do, so we can define a lack of "ability"

## World of functions and World of real objects

In ML domain, we assume that the world can be described by functions. At least working with computers requires us to speak the language of functions. However, by doing so, we also start seeing the world through the language of functions. What I mean is that, the real objects (abstract like words, or real like objects) in the real world are digitilized, represented in a computer memory, and basically the infinite complexity of real life is discritized. 

Imagine that you are trying to build a game like Minecraft, where your universe has some basic building blocks, and you can end up creating doom running machines using these basic blocks, however you are a very lazy programmer. All the basic blocks and their interactions has to be hand-codded, depending on this architecture and how you configure your parameters, you will end up with programs that have different capabilities. Achieving the highest capability, a turing complete program, is in theory not very hard, however making it interesting and a well balanced game is hard.

For example you can write a very accurate physics engine, using newtonian mechanics, where you model your environment as 1m^3 blocks, and your character can live as a different object that is associated with health and some other attributes with it's own rules and dynamics. Here you are getting close to the philosophy of object oriented programming.

Or, if you are lazy and scientifically mysticist enough, you might want to discover the theory of everything, and hopefully model 10 or 15 elemantery particles, forces etc. to create your basic dynamics. In this world, it will be almost impossible to figure out the right parameters to represent the game you imagine, however if you can do, then the open-world would literally be an open-world.

However, back to beginning, since this simulation of theory of everything lives on a computer, which is essentially a turing machine, technically we were able to create this super complex dynamics also on Minecraft. 

### Where do we live?

When one stay in computer science and ML, one forgets that the computational universe theory is just a theory. Thus this bring us to the question, is real life even a computable object. Can it ever be represented in a finite space? I will simply assume a simple "no" as an answer to this question. 

Now I will make 3 assumptions. 2 About physical domain and 1 about the time domain
  
  1 It is a materialistic world,where we will not explain human by metaphysical objects (like a soul), and we will assume that humans are computational 
  
  2 A boundry between a human and the outside world exists, where we interact with this outside world through our senses and actions (https://en.wikipedia.org/wiki/Here_is_one_hand)
  
  3 Time and causality exists, thus the ordering of events is important and effects other events only in forward time direction

fundamentally, we humans can achive some kind of intelligence, even though we consist of a physically finite space. Thus, I will assume that we create a representation of real world, which is good enough to call "intelligence", and we set this also as our goal to achive with artificial kind of intelligence. A very good exercise on this topic you can find in [this book](https://www.amazon.de/-/en/Case-Against-Reality-Evolution-Truth/dp/0393254690)

### A computational model of human

So far so good. With our assumptions above, then we can define human as an abstract computational object, a function, that senses and take actions, and most importantly learns, thus this function changes over time. What kind of a space does this function live in? Well, we don't understand necessarily, and we try to represent it as mathematical objects in our neurobiology theories (as voltages that are activated by photones or physical forces etc), however it's not important to quantify this. 

### Where does an AI model live?

Most mainstream AI models lives as a practical mathematical object, a function, usually assumed to be ideally differentiable, that has a domain and range in the Memory space (physical), and this function is encoded as instructions to be executed on a computational unit that can read from and write to this memory space. 

However, generally this memory space is higly structered, as in RGB encoding for images, or ASCII representation of text, or mp3 representation of a sound. Thus, the senses available to any AI model is defined by our technological recording capabilities and the capabilities of the machines they are working on, as well as senses available to humans are defined by their biological capabilities.

Comparing these two domains, and coming up with arguments about which one is capable of what is a very hard task, that I have no intuition about yet. The domains I am talking about until now concerns only the 1st and 2nd assumptions.

When we also consider the time and casuality part, maybe we can start to see some differences


Let's for now treat these physical operations as mathematical objects, so an AI model is a function from the memory space to memory space $`f : \mathcal{M}^n \to \mathcal{M}^m`$, and a human is a function from our sense space to our sense space $`h : \mathcal{H}^n \to \mathcal{H}^m`$. And we also know some invertible transformations between these spaces, $`t : \mathcal{M}^n \to \mathcal{H}^m`$

![](domain.png)

Thus, in the AGI discussion, our aim becomes to find a $` t, f \text{ s.t } t^{-1} \circ  f \circ t \sim h `$. Thus realizing, [the universal approximation theorem for neural networks](https://en.wikipedia.org/wiki/Universal_approximation_theorem) only works for function f, where our model is still limited by the function t. 

### How does AI models work - Practices

Finding the function t and it's inverse is easy and very intuitive. For example we represent language as sequences of integers, images as matrices of integers, thus the inverse function is also intuitive, a picture or a text on a screen. Thus is chatgpt AGI? Well, as much as it can be in the domain of sequences of integers and matrices of integers, well it can never smell for now. However the main problem with the turing test, or what we define as AGI comes from that our lack of ability to define the function f, what is intelligence itself. Thus, if we define it in a way that can be represented in the domain of chatgpt, then it could be an AGI. 

In practice, after we find a suitable transform function t, we are looking for a function f. We usually parametrize this as a neural network, assuming that it is capable of modelling any arbitrary function in form $`f : \mathcal{M}^n \to \mathcal{M}^m`$ by [the universal approximation theorem](https://en.wikipedia.org/wiki/Universal_approximation_theorem). Well, we have no reason to limit ourself to neural networks or differentiable functions, however [the gradient descent trick](https://en.wikipedia.org/wiki/Gradient_descent) is very helpful in finding our way in this complicated function domain. 

This is where the loss function comes into the play. And actually, a lot of our impilict assumptions are hidden in this step of AI models. We try to define a function where we can measure the distance between $` t^{-1} \circ  f \circ t \sim h `$. We have semantic meanings that lives in the $`\mathcal{H}`$ sense space, like this is a dog, or this is a photo of a dog. Then we try to encode this as our loss function, for example encoding a dog as 0 and a cat as 1. Usually we use a some type of distance metric, that tells how far away our models prediction is to our encoding, and we try to decrease this distance through gradient descend. 

For example, in the context of chat-gpt, given a text it tries to predict the next word. Thus our function f, is trying to approximate a probability mass function, that maps texts to a finite discrete set of values. Then does Chat-gpt think, or can it understand? Once we can define what is understanding mathematically (else we seek refuge in Wittgenstein: What can be said at all can be said clearly; and whereof one cannot speak thereof one must be silent), then we can study if set of functions, $` t^{-1} \circ  f \circ t  `$ can create something equivalent to understanding.

### But why does this method works

Until now we have investigated differences between an AI model and a human through our 1st and 2nd assumptions, without considering time. When we ask under which conditions does this method works, then we can draw some lessons from [statistical learning theory](https://en.wikipedia.org/wiki/Statistical_learning_theory), especially [Probably Approximately Correct Learning](https://en.wikipedia.org/wiki/Probably_approximately_correct_learning).

We have some good and bad news. We can probably approximately learn from a large enough dataset (w.r.t to our model capacity -VC dimention-) that is sampled from a stationary distribution. This means that as long as we have enough data w.r.t our VC dimention, with high probability we can  decrease our generalization error to a low epsilon threshold. So we can kind of learn, but what is the bad news? Bad news is that, assuming that real world is coming from a stationary distribution is just an assumption

### A little break for an epistemological discussion

Can we predict the stock market? Can we predict anything at all? Let's assume we want to check if a coin is fair or not. We flip the coing 10000 times. Let's assume in one scenario we get 10000 tails, and in other scenario we get around %50.1 tails. These two scenarios are possible with the exact same coin, just the probability of the first scenario happening is practically impossible and the second is likely. However the exact ordering of tails and heads in the second senario is still unique and as (approximately) practically impossible as the first scenario. Thus, can we ever practically test with %100 accuracy, if a coin is biased?

Or similarly, if the real world is modellable or not, is it ever tastable. Similarly, we have models of how combustion works, can we ever say %100 that our model is accurate? Or as Al-Ghazali discusses, "Just because fire usually burns cotton doesn’t mean it necessarily does so by its own nature."

### The assumption of time an causality

Then there is a very important key to our philosophical and scientific discussion. Through by-passing if the real world is modellable or not, we assume that humans have a modellable "model", thus even if we cannot model the real world, we can still model humans, thus approximate it by a neural network. However this doesn't say anything about the stationarity of our distribution.

### The stationary distribution assumption

What arguments do we have to assume a stationary distribution? One can argue that, if you could predict the stock market, you would fundamentally change the human behaviour, thus you would change the stock market itself, thus the moment you model a stock market, your model would be obselete (or in practice will start being less and less accurate over time). However, one can study the human behaviour, and maybe can find a stable baseline, thus accounting for each possibility of the stock market. Or taking this argument too far, one can model every atom in the universe and by our first and second assumptions, can predict the stock market at the end of the day. 

However, maybe we can argue for an "unstationary distribution" in different domains. For example, even if the universe might have some constants, we humans, through natural selection, learned to sense a subset of physical reality around us, that helps us to survive through this low dimentional representation. Thus, also getting inspired by social sciences and psychology, it seems more fit to assume that we thrive on adapting to the changes in the underlying distribution while we are learning the world.

### So, What is an AI model not?

AI models are stationary. Generally defined as training and then inference times. For example, chat-gpt learn over the language available as of 2025, and once it is deployed, (assuming it will not be further trained), it's understanding of language is fixed. However, language in reality is alive and changes.

The argument for this change, and AI model cannot capture a language that is universal is simple. Simply take a language dictionary (as they are represented by GPT models). Then change the meaning of every word to another arbitrary word (Like instead of the word "Table" we start using "Car". This is still english and it is consistent, and humans could have come up with this version of english. Thus even if AI model can cupture somtehing like "Universal Grammer" the symbolic represantation of the words can always evolve through time, as it is almost the case, and happening right before our eyes with generational gaps.

How can we model this? The moment we finish training, we finish at a point in our landscape. It's impossible to imagine the landscape that is spanned by billions of parameters, however the analogy is useful. Then, assuming we do not further train the loss landscape, the landscape start changing while we are standing still. Thus errosions happens, and over time we end up on a totally changed landscape, and it is very much likely that we would be on a worse loss value that we were, since worse loss values are simply more common.

### Quick Linguistic Discussion

When we learn latin to study antique history, and when we read texts that are 600 years apart from each other, can we use the same latin knowledge to read both texts? Well, very concretely, phrases, words, grammer do change. However, it's still a very similar language. But more importantly, people and the social culture changes. Maybe what is important for people in 300 B.C is not important anymore for people in 300 A.D, but expressions in language stays. Maybe the same word "Ceaser", used to be a casual name in 300 B.C, where in 300 A.D started to be associated with imperors. In social sciences, you would see a lot of discussion, how envrionment and our paradigms can effect the symbolic meanings in the language and how it shapes our perception. A good example that takes this idea to its extreme is [the bicameral mind](https://en.wikipedia.org/wiki/Bicameral_mentality).

Thus, in the mainstream sense an AI model is not alive, that is adaptable to the changes in the change in it's loss landscape. Our understanding simply assumes a constant loss function that should be optimized over. 

As well as our AI model is limited by it's data gathering capabilities. For example let's assume we are trying to score romantic matching between humans. We collect data about peoples background as text and their appearances as images but we do not collect any smell/chemical information, that is about their pheromones. And let's assume that the romantic match is %90 characterized by these pheromones, then with the information we can collect, we might never be able to get an accurate model.

These two concepts are very related to eachother. The first one says that it is not capable of change itself with the changing environment. The second one says that it is not able to explore the world as freely as it wants and always limited by our design of the data structure. Thus even if it was capable of changing itself to suit the environment, it might not even be able to detect these changes. Thus, our design of the input data, also consists of our implicit assumptions about the task at hand.

### A Quick Summary

There are two points where we bring implicit assumptions

1 Design of the loss function

2 Design of our input domain, data structure etc

Thus our hypothesis space is as limited as our assumptions limits us. However, I belive we can parametrize the design of loss function and design of our input domain/data structure, through changing how we build our AI models. However, by parametrizing these 2 structure, we start losing our ability to shape the AI model to our wishes, thus it comes with a natural trade-off between understandability and model complexity

I am planing to write on this idea more in the future.
