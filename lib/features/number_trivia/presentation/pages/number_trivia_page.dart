import '../../domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: buildBody(size),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(Size size) {
    TextEditingController controller = TextEditingController();
    // ignore: close_sinks

    return BlocProvider<NumberTriviaBloc>(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Column(
          children: [
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (BuildContext context, state) {
              if (state is EmptyState) {
                return Container(
                  width: size.width,
                  height: 500,
                  color: Colors.amber,
                  child: Center(child: Text("EMPTY STATE")),
                );
              } else if (state is LoadedState) {
                return Trivia(numberTrivia: state.trivia, size: size);
              } else if (state is ErrorState) {
                return ErrorLoading(size: size, message: state.message);
              } else {
                return TriviaLoading(size: size);
              }
            }),
            TriviaController(controller: controller),
          ],
        ));
  }
}

class TriviaController extends StatelessWidget {
  const TriviaController({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(30),
            child: TextField(controller: controller)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
                onPressed: () => BlocProvider.of<NumberTriviaBloc>(context)
                    .add(GetTriviaForRandomNumber()),
                icon: Icon(Icons.text_rotation_down),
                label: Text('Random Trivia')),
            FlatButton.icon(
                onPressed: () => BlocProvider.of<NumberTriviaBloc>(context).add(
                    GetTriviaForConcreteNumber(numberString: controller.text)),
                icon: Icon(Icons.format_list_numbered_rtl),
                label: Text('Number Trivia'))
          ],
        )
      ],
    );
  }
}

class Trivia extends StatelessWidget {
  final Size size;
  final NumberTrivia numberTrivia;
  Trivia({@required this.size, @required this.numberTrivia});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(numberTrivia.number.toString(),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 120),
          Container(
            padding: EdgeInsets.all(20),
            width: size.width,
            child: Center(child: Text(numberTrivia.text)),
          ),
        ],
      ),
    );
  }
}

class TriviaLoading extends StatelessWidget {
  final Size size;
  TriviaLoading({@required this.size});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          SizedBox(height: 155),
          Container(
            padding: EdgeInsets.all(20),
            width: size.width,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class ErrorLoading extends StatelessWidget {
  final Size size;
  final String message;
  ErrorLoading({@required this.size, @required this.message});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          SizedBox(height: 120),
          Container(
            padding: EdgeInsets.all(20),
            width: size.width,
            child: Center(
                child: Icon(
              Icons.sentiment_very_dissatisfied,
              size: 120,
              color: Colors.grey,
            )),
          ),
          Text(message)
        ],
      ),
    );
  }
}
