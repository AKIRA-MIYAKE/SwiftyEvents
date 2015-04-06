SwiftyEvents
======================
SwiftyEventsはnode.jsのEventEmitterに影響を受けた、イベント通知のためのライブラリです。  
NSNotificationより簡易に使うことができ、またNSObjectに依存しないことを目指して開発されています。  

# EventEmitter
`EventEmitter`オブジェクトは、指定されたイベントに対するイベントリスナを登録することができ、イベントが発生した際に登録されたイベントリスナの関数を実行することができます。

## Creating EventEmitter
```
init<Event: Hashable, Argument: Any>()
```
`EventEmitter`オブジェクトの生成時に、イベントの判別に用いる型と、イベント発生時に実行される関数の引数の型を指定します。  
イベントは`Hashable`プロトコルを実装していることが必要です。通常の文字列を用いることも可能ですが、enum型を用いることでより安全なコードを記述することが可能です。  

## Adding Listeners
```
func on(event: Event, _ function: Argument -> Void) -> Listener<Argument>
```
```
func on(event: Event, listener: Listener<Argument>) -> Listener<Argument>
```
指定されたイベントに対するリスナーを追加します。  
関数を用いて追加した際には、関数を含んだ`Listener`オブジェクトが生成され、返却されます。  

```
func once(event: Event, _ function: Argument -> Void) -> Listener<Argument>
```
一度限りのリスナーをイベントに追加します。  
このメソッドにより生成された`Listener`オブジェクトの関数は、初回の一度しか実行されません。  

## Removing Listeners
```
func removeListener(event: Event, listener: Listener<Argument>) -> Void
```
`EventEmitter`オブジェクトに登録された指定されたイベントに対するリスナを削除します。  

```
func removeAllListeners() -> Void
```
`EventEmitter`オブジェクトに登録されている、全てのリスナを削除します。  
```
func removeAllListeners(events: [Event]) -> Void
```
`EventEmitter`オブジェクトの指定したイベントに対する全てのリスナを削除します。  

## Getting Listeners
```
func listeners(event: Event) -> [Listener<Argument>]
```
指定されたイベントに対するリスナを返却します。  

## Emitting
```
func emit(event: Event, argument: Argument) -> Bool
```
指定されたイベントに登録されたリスナの関数を、提供された引数を用いて実行します。  
イベントに対応するリスナが存在していた場合は`true`を、それ以外は`false`を返します。  

## Creating Listener
```
func newListener(function: Argument -> Void) -> Listener<Argument>
```
引数の関数を含んだ`Listener`オブジェクトを生成します。  

# Listener
`Listener`オブジェクトは、`EventEmitter`オブジェクトがイベント発生時に実行する関数を含むオブジェクトです。  

## Creating Listener
```
init<Argument: Any>(function: Argument -> Void)
```
`EventEmitter`オブジェクトにより実行される関数を引数として、`Listener`オブジェクトを生成します。  
`EventEmitter`オブジェクトの`newListener`メソッドを利用することにより、その`EventEmitter`オブジェクトで受け入れ可能な型の`Listener`オブジェクトを得ることができます。  

## Executing Function
```
func exec(argument: Argument) -> Void
```
`Listener`オブジェクト生成時に引数として与えた関数を実行します。  
`EventEmitter`の`Emit()`メソッドでは、基本的にこのメソッドを用いて関数が実行されます。  

License
----------
Copyright &copy; 2015 AKIRA-MIYAKE
Distributed under the [MIT License][mit].

[MIT]: http://www.opensource.org/licenses/mit-license.php
