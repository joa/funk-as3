/*
 * This file is part of funk-as3.
 *
 * funk-as3 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * funk-as3 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Apparat. If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright (C) 2010 Joa Ebert
 * http://www.joa-ebert.com/
 */

package flashx.funk.option {
  import flashx.funk.IFunkObject;
  import flashx.funk.Product;
  import flashx.funk.error.IndexOutOfBoundsError;
  import flashx.funk.error.NoSuchElementError;
  import flashx.funk.util.verifiedType;

  internal final class NoneImpl extends Product implements IOption {
    public function get get(): * {
      throw new NoSuchElementError()
    }

    public function getOrElse(f: Function): * {
      return f()
    }

    public function get isDefined(): Boolean {
      return false
    }

    public function get isEmpty(): Boolean {
      return true
    }

    override public function equals(that: *): Boolean {
      if (that is IOption) {
        return !IOption(that).isDefined
      }

      return false
    }

    override public function get productArity(): int {
      return 0
    }

    override public function productElement(i: int): * {
      throw new IndexOutOfBoundsError()
    }

    override public function get productPrefix(): String {
      return "None"
    }

    public function filter(f: Function): IOption {
      return this
    }

    public function foreach(f: Function): void {
    }

    public function flatMap(f: Function): IOption {
      return this
    }
    
    public function map(f: Function): IOption {
      return this
    }

    public function orElse(f: Function): IOption {
      return verifiedType(f(), IOption)
    }
  }
}