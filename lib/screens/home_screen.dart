import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../contants/const_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OpenWeather_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weather = await _wf.currentWeatherByCityName("Sukkur");
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather data: $e");
      // Handle error gracefully, e.g., show error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: _weather != null ? _buildWeatherDetails() : _buildLoadingIndicator(),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildWeatherDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLocationHeader(),
          const SizedBox(height: 20.0),
          _buildDateTimeInfo(),
          const SizedBox(height: 20.0),
          _buildWeatherIcon(),
          const SizedBox(height: 20.0),
          _buildCurrentTemp(),
          const SizedBox(height: 20.0),
          _buildExtraInfo(),
        ],
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          DateFormat("EEEE, d MMMM y").format(now),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon() {
    return Column(
      children: [
        Image.network(
          "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildExtraInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem("Max Temp", "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C"),
              _buildInfoItem("Min Temp", "${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem("Wind Speed", "${_weather?.windSpeed?.toStringAsFixed(0)} m/s"),
              _buildInfoItem("Humidity", "${_weather?.humidity?.toStringAsFixed(0)}%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
